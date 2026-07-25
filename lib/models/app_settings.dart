import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(3) int concurrentDownloads,
    @Default(5) int retryCount,
    @Default(true) bool autoResume,
    @Default(true) bool showNotifications,
    @Default('dark') String themeMode,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
}
