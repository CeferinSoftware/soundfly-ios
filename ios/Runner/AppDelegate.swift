import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Configure AVAudioSession for background audio playback
    configureAudioSession()
    
    // Firebase and push notifications are handled by Flutter plugins
    // No native initialization needed here
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func configureAudioSession() {
    do {
      let audioSession = AVAudioSession.sharedInstance()
      
      // Set category for playback that can mix with other apps
      // .playback allows audio to continue in background
      // .mixWithOthers allows audio from other apps to play simultaneously if needed
      try audioSession.setCategory(
        .playback,
        mode: .default,
        options: [.allowAirPlay, .allowBluetooth, .allowBluetoothA2DP]
      )
      
      // Activate the audio session
      try audioSession.setActive(true)
      
      print("Audio session configured successfully for background playback")
    } catch {
      print("Failed to configure audio session: \(error.localizedDescription)")
    }
  }
  
  // Handle audio interruptions (phone calls, etc.)
  override func applicationWillResignActive(_ application: UIApplication) {
    // App is about to move to background - keep audio playing
    super.applicationWillResignActive(application)
  }
  
  override func applicationDidBecomeActive(_ application: UIApplication) {
    // App came back to foreground
    super.applicationDidBecomeActive(application)
  }
}
