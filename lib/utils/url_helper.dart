import 'package:url_launcher/url_launcher.dart';

/// URL Helper utility class
/// 
/// Provides methods for handling URLs, including opening external links
/// and validating URLs.
class UrlHelper {
  /// Open URL in external browser
  static Future<bool> openUrl(String url) async {
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
    return false;
  }

  /// Open URL in app browser (WebView)
  static Future<bool> openUrlInApp(String url) async {
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
      );
    }
    return false;
  }

  /// Open email client
  static Future<bool> sendEmail({
    required String email,
    String? subject,
    String? body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }

  /// Open phone dialer
  static Future<bool> makePhoneCall(String phoneNumber) async {
    final uri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }

  /// Open SMS app
  static Future<bool> sendSms(String phoneNumber, [String? message]) async {
    final uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: message != null ? {'body': message} : null,
    );

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }

  /// Check if URL is valid
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }

  /// Check if URL is an external link (different domain)
  static bool isExternalUrl(String url, String baseUrl) {
    try {
      final uri = Uri.parse(url);
      final base = Uri.parse(baseUrl);
      return uri.host != base.host;
    } catch (_) {
      return true;
    }
  }

  /// Get domain from URL
  static String? getDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (_) {
      return null;
    }
  }

  /// Check if URL is a download link
  static bool isDownloadUrl(String url) {
    final downloadExtensions = [
      '.mp3', '.mp4', '.m4a', '.wav', '.flac', '.aac', '.ogg',
      '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx',
      '.zip', '.rar', '.7z', '.tar', '.gz',
      '.jpg', '.jpeg', '.png', '.gif', '.webp', '.svg',
    ];

    final lowercaseUrl = url.toLowerCase();
    return downloadExtensions.any((ext) => lowercaseUrl.endsWith(ext));
  }
}
