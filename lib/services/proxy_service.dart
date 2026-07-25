import 'package:flutter/services.dart';
import '../core/constants/app_constants.dart';
import '../models/proxy_config.dart';

class ProxyService {
  final MethodChannel _keychainChannel = const MethodChannel(AppConstants.keychainChannel);

  Future<void> saveProxyCredentials(ProxyConfig config) async {
    if (config.username.isEmpty || config.password.isEmpty) return;
    
    await _keychainChannel.invokeMethod('saveCredentials', {
      'host': config.host,
      'username': config.username,
      'password': config.password,
    });
  }

  Future<Map<String, String>?> getProxyCredentials(String host) async {
    final Map<dynamic, dynamic>? result = await _keychainChannel.invokeMethod('getCredentials', {
      'host': host,
    });
    if (result == null) return null;
    return result.cast<String, String>();
  }

  Future<void> deleteProxyCredentials(String host) async {
    await _keychainChannel.invokeMethod('deleteCredentials', {
      'host': host,
    });
  }
}
