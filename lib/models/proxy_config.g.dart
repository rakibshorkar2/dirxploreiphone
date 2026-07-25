// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProxyConfigImpl _$$ProxyConfigImplFromJson(Map<String, dynamic> json) =>
    _$ProxyConfigImpl(
      id: json['id'] as String,
      host: json['host'] as String,
      port: (json['port'] as num).toInt(),
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      isEnabled: json['isEnabled'] as bool? ?? true,
      type: json['type'] as String? ?? 'SOCKS5',
    );

Map<String, dynamic> _$$ProxyConfigImplToJson(_$ProxyConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'host': instance.host,
      'port': instance.port,
      'username': instance.username,
      'password': instance.password,
      'isEnabled': instance.isEnabled,
      'type': instance.type,
    };
