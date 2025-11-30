import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity Service
/// 
/// Handles internet connectivity checking and monitoring.
class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _subscription;
  static bool _isConnected = true;

  /// Check if device is connected to internet
  static Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && results.first != ConnectivityResult.none;
  }

  /// Get current connectivity status
  static bool get currentStatus => _isConnected;

  /// Start listening to connectivity changes
  static void startListening(Function(bool) onConnectivityChanged) {
    _subscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final isConnected = results.isNotEmpty && 
            results.first != ConnectivityResult.none;
        
        if (isConnected != _isConnected) {
          _isConnected = isConnected;
          onConnectivityChanged(isConnected);
        }
      },
    );
  }

  /// Stop listening to connectivity changes
  static void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Get connectivity type
  static Future<String> getConnectivityType() async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty) return 'None';
    
    switch (results.first) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
      default:
        return 'None';
    }
  }
}
