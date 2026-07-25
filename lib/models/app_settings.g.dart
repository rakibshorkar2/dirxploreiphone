// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      concurrentDownloads: (json['concurrentDownloads'] as num?)?.toInt() ?? 3,
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 5,
      autoResume: json['autoResume'] as bool? ?? true,
      showNotifications: json['showNotifications'] as bool? ?? true,
      themeMode: json['themeMode'] as String? ?? 'dark',
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'concurrentDownloads': instance.concurrentDownloads,
      'retryCount': instance.retryCount,
      'autoResume': instance.autoResume,
      'showNotifications': instance.showNotifications,
      'themeMode': instance.themeMode,
    };
