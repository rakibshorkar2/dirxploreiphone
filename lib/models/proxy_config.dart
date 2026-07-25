import 'package:freezed_annotation/freezed_annotation.dart';

part 'proxy_config.freezed.dart';
part 'proxy_config.g.dart';

@freezed
class ProxyConfig with _$ProxyConfig {
  const factory ProxyConfig({
    required String id,
    required String host,
    required int port,
    @Default('') String username,
    @Default('') String password,
    @Default(true) bool isEnabled,
    @Default('SOCKS5') String type,
  }) = _ProxyConfig;

  factory ProxyConfig.fromJson(Map<String, dynamic> json) => _$ProxyConfigFromJson(json);
}
