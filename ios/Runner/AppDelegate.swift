import UIKit
import Flutter
import AVFoundation
import WebKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Register native audio player plugin
    if let registrar = self.registrar(forPlugin: "NativeAudioPlayerPlugin") {
      NativeAudioPlayerPlugin.register(with: registrar)
    }
    
    // Configure AVAudioSession for background audio playback
    configureAudioSession()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func configureAudioSession() {
    do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(
        .playback,
        mode: .default,
        options: [.allowAirPlay, .allowBluetooth, .allowBluetoothA2DP]
      )
      try audioSession.setActive(true)
      print("Audio session configured successfully for background playback")
    } catch {
      print("Failed to configure audio session: \(error.localizedDescription)")
    }
  }
  
  override func applicationDidEnterBackground(_ application: UIApplication) {
    do {
      try AVAudioSession.sharedInstance().setActive(true)
      print("Audio session kept active in background")
    } catch {
      print("Failed to keep audio session active: \(error)")
    }
    super.applicationDidEnterBackground(application)
  }
  
  override func applicationWillEnterForeground(_ application: UIApplication) {
    do {
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Failed to activate audio session: \(error)")
    }
    super.applicationWillEnterForeground(application)
  }
}
