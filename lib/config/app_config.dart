/// Configuration file for Soundfly iOS App
/// 
/// This file contains all the configurable settings for the app.
/// Update these values to match your Soundfly web backend configuration.

class AppConfig {
  // ===========================================
  // APP INFORMATION
  // ===========================================
  
  /// App name displayed in the UI
  static const String appName = 'Soundfly';
  
  /// App version
  static const String appVersion = '14.0';
  
  /// Build number
  static const int buildNumber = 14000;
  
  // ===========================================
  // WEBSITE CONFIGURATION
  // ===========================================
  
  /// Your Soundfly website URL
  /// Change this to your website URL
  static const String websiteUrl = 'https://soundfly.es';
  
  /// Purchase code from CodeCanyon
  static const String purchaseCode = 'Your Purchase Code Here';
  
  // ===========================================
  // PUSH NOTIFICATIONS (Firebase)
  // ===========================================
  
  /// Set to true to enable push notifications
  static const bool pushNotificationsEnabled = false;
  
  /// Firebase project settings (from google-services.json / GoogleService-Info.plist)
  static const String gcmSenderId = 'Your Project Number Here';
  static const String googleApiKey = 'Your Current API Key Here';
  static const String googleAppId = 'Your MobileSDK App ID Here';
  static const String googleStorageBucket = 'Your Storage Bucket Value Here';
  static const String projectId = 'Your Project ID Here';
  
  // ===========================================
  // ADMOB CONFIGURATION
  // ===========================================
  
  /// Set to true to enable AdMob interstitial ads
  static const bool admobEnabled = false;
  
  /// AdMob App ID (iOS)
  /// Test ID: ca-app-pub-3940256099942544~1458002511
  static const String admobAppId = 'ca-app-pub-3940256099942544~1458002511';
  
  /// AdMob Interstitial Ad Unit ID (iOS)
  /// Test ID: ca-app-pub-3940256099942544/4411468910
  static const String admobInterstitialId = 'ca-app-pub-3940256099942544/4411468910';
  
  /// Show interstitial ad after every X page loads
  static const int interstitialInterval = 5;
  
  // ===========================================
  // UI CONFIGURATION
  // ===========================================
  
  /// Enable fullscreen mode (hides status bar)
  static const bool fullscreenEnabled = false;
  
  /// Primary color (splash screen background)
  static const int primaryColorValue = 0xFFFF3044;
  
  /// Splash screen duration in milliseconds
  static const int splashDuration = 2000;
  
  // ===========================================
  // FEATURE FLAGS
  // ===========================================
  
  /// Enable file downloads
  static const bool downloadsEnabled = true;
  
  /// Enable external links to open in Safari
  static const bool openExternalLinksInBrowser = true;
  
  /// Enable pull to refresh
  static const bool pullToRefreshEnabled = true;
  
  /// Enable JavaScript in WebView
  static const bool javascriptEnabled = true;
  
  /// Enable DOM storage in WebView
  static const bool domStorageEnabled = true;
  
  // ===========================================
  // CONNECTIVITY
  // ===========================================
  
  /// Check connectivity on app start
  static const bool checkConnectivityOnStart = true;
  
  /// Retry button delay in milliseconds
  static const int retryDelay = 1000;
}
