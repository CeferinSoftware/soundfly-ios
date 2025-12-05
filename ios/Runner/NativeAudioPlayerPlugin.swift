import Foundation
import AVFoundation
import MediaPlayer
import Flutter

/// Native Audio Player for background audio playback
/// Uses AVPlayer which supports background audio unlike WKWebView
class NativeAudioPlayerPlugin: NSObject, FlutterPlugin {
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var channel: FlutterMethodChannel?
    private var timeObserver: Any?
    private var currentURL: String?
    
    // Track info for lock screen
    private var trackTitle: String = "Soundfly"
    private var trackArtist: String = ""
    private var trackDuration: Double = 0
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.soundfly.music/audio",
            binaryMessenger: registrar.messenger()
        )
        let instance = NativeAudioPlayerPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // Setup audio session
        instance.setupAudioSession()
        
        // Setup remote command center (lock screen controls)
        instance.setupRemoteCommandCenter()
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "play":
            if let args = call.arguments as? [String: Any],
               let url = args["url"] as? String {
                play(url: url)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGS", message: "URL required", details: nil))
            }
            
        case "pause":
            pause()
            result(nil)
            
        case "resume":
            resume()
            result(nil)
            
        case "stop":
            stop()
            result(nil)
            
        case "seek":
            if let args = call.arguments as? [String: Any],
               let position = args["position"] as? Double {
                seek(to: position)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGS", message: "Position required", details: nil))
            }
            
        case "setVolume":
            if let args = call.arguments as? [String: Any],
               let volume = args["volume"] as? Double {
                setVolume(Float(volume))
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGS", message: "Volume required", details: nil))
            }
            
        case "getState":
            result(getState())
            
        case "getPosition":
            result(getPosition())
            
        case "getDuration":
            result(getDuration())
            
        case "setTrackInfo":
            if let args = call.arguments as? [String: Any] {
                trackTitle = args["title"] as? String ?? "Soundfly"
                trackArtist = args["artist"] as? String ?? ""
                trackDuration = args["duration"] as? Double ?? 0
                updateNowPlayingInfo()
                result(nil)
            } else {
                result(nil)
            }
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(
                .playback,
                mode: .default,
                options: [.allowAirPlay, .allowBluetooth, .allowBluetoothA2DP]
            )
            try audioSession.setActive(true)
            
            // Listen for interruptions
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleInterruption),
                name: AVAudioSession.interruptionNotification,
                object: audioSession
            )
            
            // Listen for route changes (headphones unplugged, etc.)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleRouteChange),
                name: AVAudioSession.routeChangeNotification,
                object: audioSession
            )
            
            print("Audio session configured for background playback")
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Play command
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.resume()
            return .success
        }
        
        // Pause command
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
        
        // Toggle play/pause
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            if self?.player?.rate == 0 {
                self?.resume()
            } else {
                self?.pause()
            }
            return .success
        }
        
        // Skip forward
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [15]
        commandCenter.skipForwardCommand.addTarget { [weak self] event in
            guard let skipEvent = event as? MPSkipIntervalCommandEvent else { return .commandFailed }
            let currentTime = self?.getPosition() ?? 0
            self?.seek(to: currentTime + skipEvent.interval)
            return .success
        }
        
        // Skip backward
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.preferredIntervals = [15]
        commandCenter.skipBackwardCommand.addTarget { [weak self] event in
            guard let skipEvent = event as? MPSkipIntervalCommandEvent else { return .commandFailed }
            let currentTime = self?.getPosition() ?? 0
            self?.seek(to: max(0, currentTime - skipEvent.interval))
            return .success
        }
        
        // Seek bar
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let positionEvent = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            self?.seek(to: positionEvent.positionTime)
            return .success
        }
    }
    
    private func play(url: String) {
        // Stop any current playback
        stop()
        
        currentURL = url
        
        guard let audioURL = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }
        
        playerItem = AVPlayerItem(url: audioURL)
        player = AVPlayer(playerItem: playerItem)
        
        // Observe player status
        playerItem?.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
        
        // Observe when playback ends
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        // Add time observer for progress updates
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            let position = CMTimeGetSeconds(time)
            self?.channel?.invokeMethod("onProgressChanged", arguments: position)
            self?.updateNowPlayingInfo()
        }
        
        player?.play()
        
        channel?.invokeMethod("onPlaybackStateChanged", arguments: "playing")
        updateNowPlayingInfo()
        
        print("Playing audio from: \(url)")
    }
    
    private func pause() {
        player?.pause()
        channel?.invokeMethod("onPlaybackStateChanged", arguments: "paused")
        updateNowPlayingInfo()
    }
    
    private func resume() {
        // Ensure audio session is active
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to activate audio session: \(error)")
        }
        
        player?.play()
        channel?.invokeMethod("onPlaybackStateChanged", arguments: "playing")
        updateNowPlayingInfo()
    }
    
    private func stop() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        
        player?.pause()
        player = nil
        playerItem = nil
        currentURL = nil
        
        channel?.invokeMethod("onPlaybackStateChanged", arguments: "stopped")
        
        // Clear now playing info
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
    
    private func seek(to position: Double) {
        let time = CMTime(seconds: position, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: time)
    }
    
    private func setVolume(_ volume: Float) {
        player?.volume = volume
    }
    
    private func getState() -> String {
        guard let player = player else { return "stopped" }
        if player.rate > 0 {
            return "playing"
        } else {
            return "paused"
        }
    }
    
    private func getPosition() -> Double {
        guard let player = player else { return 0 }
        return CMTimeGetSeconds(player.currentTime())
    }
    
    private func getDuration() -> Double {
        guard let duration = playerItem?.duration else { return 0 }
        let seconds = CMTimeGetSeconds(duration)
        return seconds.isNaN ? 0 : seconds
    }
    
    private func updateNowPlayingInfo() {
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: trackTitle,
            MPMediaItemPropertyArtist: trackArtist,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: getPosition(),
            MPMediaItemPropertyPlaybackDuration: getDuration(),
            MPNowPlayingInfoPropertyPlaybackRate: player?.rate ?? 0
        ]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            // Interruption began (phone call, etc.)
            pause()
            print("Audio interrupted")
            
        case .ended:
            // Interruption ended
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    resume()
                    print("Audio resuming after interruption")
                }
            }
            
        @unknown default:
            break
        }
    }
    
    @objc private func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        
        switch reason {
        case .oldDeviceUnavailable:
            // Headphones were unplugged - pause
            pause()
            print("Audio output device removed, pausing")
        default:
            break
        }
    }
    
    @objc private func playerDidFinishPlaying(notification: Notification) {
        channel?.invokeMethod("onPlaybackStateChanged", arguments: "completed")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let status = playerItem?.status {
                switch status {
                case .readyToPlay:
                    print("Player ready to play")
                case .failed:
                    print("Player failed: \(playerItem?.error?.localizedDescription ?? "unknown error")")
                    channel?.invokeMethod("onPlaybackStateChanged", arguments: "error")
                case .unknown:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }
}
