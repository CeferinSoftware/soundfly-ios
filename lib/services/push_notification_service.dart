/// Push Notification Service
/// 
/// Push notifications are temporarily disabled due to Firebase/Xcode compatibility issues.
/// This will be enabled in a future update when the issue is resolved.
/// 
/// The web app at soundfly.es can still send notifications through the browser.
class PushNotificationService {
  static Future<void> initialize() async {
    // Temporarily disabled
    print('Push notifications: temporarily disabled for iOS build compatibility');
  }

  static Future<void> subscribeToTopic(String topic) async {
    // Temporarily disabled
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    // Temporarily disabled
  }
}
