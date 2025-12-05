import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Native Audio Player Service
/// 
/// Uses a native iOS audio player (AVPlayer) to play audio
/// which supports background playback, unlike WKWebView.
class NativeAudioPlayer {
  static const MethodChannel _channel = MethodChannel('com.soundfly.music/audio');
  
  static bool _isInitialized = false;
  static Function(String)? onPlaybackStateChanged;
  static Function(double)? onProgressChanged;
  
  /// Initialize the native audio player
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    _channel.setMethodCallHandler(_handleMethodCall);
    _isInitialized = true;
    debugPrint('Native audio player initialized');
  }
  
  /// Handle method calls from native side
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPlaybackStateChanged':
        final state = call.arguments as String;
        onPlaybackStateChanged?.call(state);
        break;
      case 'onProgressChanged':
        final progress = call.arguments as double;
        onProgressChanged?.call(progress);
        break;
      default:
        debugPrint('Unknown method call: ${call.method}');
    }
  }
  
  /// Play audio from URL
  static Future<void> play(String url) async {
    try {
      await _channel.invokeMethod('play', {'url': url});
      debugPrint('Playing audio: $url');
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }
  
  /// Pause audio
  static Future<void> pause() async {
    try {
      await _channel.invokeMethod('pause');
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }
  
  /// Resume audio
  static Future<void> resume() async {
    try {
      await _channel.invokeMethod('resume');
    } catch (e) {
      debugPrint('Error resuming audio: $e');
    }
  }
  
  /// Stop audio
  static Future<void> stop() async {
    try {
      await _channel.invokeMethod('stop');
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }
  
  /// Seek to position (in seconds)
  static Future<void> seek(double position) async {
    try {
      await _channel.invokeMethod('seek', {'position': position});
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }
  
  /// Set volume (0.0 to 1.0)
  static Future<void> setVolume(double volume) async {
    try {
      await _channel.invokeMethod('setVolume', {'volume': volume});
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }
  
  /// Get current playback state
  static Future<String> getState() async {
    try {
      return await _channel.invokeMethod('getState') ?? 'stopped';
    } catch (e) {
      debugPrint('Error getting state: $e');
      return 'stopped';
    }
  }
  
  /// Get current position in seconds
  static Future<double> getPosition() async {
    try {
      return await _channel.invokeMethod('getPosition') ?? 0.0;
    } catch (e) {
      debugPrint('Error getting position: $e');
      return 0.0;
    }
  }
  
  /// Get duration in seconds
  static Future<double> getDuration() async {
    try {
      return await _channel.invokeMethod('getDuration') ?? 0.0;
    } catch (e) {
      debugPrint('Error getting duration: $e');
      return 0.0;
    }
  }
}
