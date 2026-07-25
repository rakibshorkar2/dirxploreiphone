import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/proxy_config.dart';
import '../services/proxy_service.dart';
import '../core/constants/app_constants.dart';

final proxyServiceProvider = Provider((ref) => ProxyService());

final proxyListProvider = StateNotifierProvider<ProxyListNotifier, List<ProxyConfig>>((ref) {
  final service = ref.watch(proxyServiceProvider);
  return ProxyListNotifier(service);
});

class ProxyListNotifier extends StateNotifier<List<ProxyConfig>> {
  final ProxyService _service;
  ProxyListNotifier(this._service) : super([]) {
    _loadProxies();
  }

  static const _key = 'proxy_configs';

  Future<void> _loadProxies() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      final List<dynamic> decoded = json.decode(jsonString);
      state = decoded.map((e) => ProxyConfig.fromJson(e)).toList();
    } else {
      // Add default proxy from constants if none exists
      final defaultProxy = ProxyConfig(
        id: const Uuid().v4(),
        host: AppConstants.defaultProxyHost,
        port: AppConstants.defaultProxyPort,
        username: AppConstants.defaultProxyUser,
        password: AppConstants.defaultProxyPass,
        isEnabled: false,
      );
      state = [defaultProxy];
      _saveProxies();
    }
  }

  Future<void> addProxy(ProxyConfig proxy) async {
    state = [...state, proxy];
    await _service.saveProxyCredentials(proxy);
    await _saveProxies();
  }

  Future<void> updateProxy(ProxyConfig proxy) async {
    state = [
      for (final p in state)
        if (p.id == proxy.id) proxy else p
    ];
    await _service.saveProxyCredentials(proxy);
    await _saveProxies();
  }

  Future<void> deleteProxy(String id) async {
    final proxy = state.firstWhere((p) => p.id == id);
    state = state.where((p) => p.id != id).toList();
    await _service.deleteProxyCredentials(proxy.host);
    await _saveProxies();
  }

  Future<void> _saveProxies() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(state.map((e) => e.toJson()).toList()));
  }

  ProxyConfig? get activeProxy {
    try {
      return state.firstWhere((p) => p.isEnabled);
    } catch (_) {
      return null;
    }
  }

  Future<void> toggleProxy(String id) async {
    state = [
      for (final p in state)
        if (p.id == id) p.copyWith(isEnabled: !p.isEnabled) 
        else p.copyWith(isEnabled: false) // Only one active at a time
    ];
    await _saveProxies();
  }
}
