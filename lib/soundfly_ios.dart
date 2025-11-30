/// Soundfly iOS App
/// 
/// This is the main entry point for the Soundfly iOS application.
/// The app provides a native iOS experience for the Soundfly music streaming platform.
/// 
/// Features:
/// - WebView integration with the Soundfly web backend
/// - Push notifications via Firebase
/// - AdMob integration for monetization
/// - Offline detection with retry functionality
/// - Native iOS styling and animations
/// 
/// Configuration:
/// Update the values in lib/config/app_config.dart to configure the app.

library soundfly_ios;

export 'config/app_config.dart';
export 'config/app_strings.dart';
export 'config/app_theme.dart';
export 'screens/splash_screen.dart';
export 'screens/home_screen.dart';
export 'screens/no_internet_screen.dart';
export 'services/admob_service.dart';
export 'services/push_notification_service.dart';
export 'services/connectivity_service.dart';
