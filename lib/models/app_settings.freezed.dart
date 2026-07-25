// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  int get concurrentDownloads => throw _privateConstructorUsedError;
  int get retryCount => throw _privateConstructorUsedError;
  bool get autoResume => throw _privateConstructorUsedError;
  bool get showNotifications => throw _privateConstructorUsedError;
  String get themeMode => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {int concurrentDownloads,
      int retryCount,
      bool autoResume,
      bool showNotifications,
      String themeMode});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? concurrentDownloads = null,
    Object? retryCount = null,
    Object? autoResume = null,
    Object? showNotifications = null,
    Object? themeMode = null,
  }) {
    return _then(_value.copyWith(
      concurrentDownloads: null == concurrentDownloads
          ? _value.concurrentDownloads
          : concurrentDownloads // ignore: cast_nullable_to_non_nullable
              as int,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      autoResume: null == autoResume
          ? _value.autoResume
          : autoResume // ignore: cast_nullable_to_non_nullable
              as bool,
      showNotifications: null == showNotifications
          ? _value.showNotifications
          : showNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int concurrentDownloads,
      int retryCount,
      bool autoResume,
      bool showNotifications,
      String themeMode});
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? concurrentDownloads = null,
    Object? retryCount = null,
    Object? autoResume = null,
    Object? showNotifications = null,
    Object? themeMode = null,
  }) {
    return _then(_$AppSettingsImpl(
      concurrentDownloads: null == concurrentDownloads
          ? _value.concurrentDownloads
          : concurrentDownloads // ignore: cast_nullable_to_non_nullable
              as int,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      autoResume: null == autoResume
          ? _value.autoResume
          : autoResume // ignore: cast_nullable_to_non_nullable
              as bool,
      showNotifications: null == showNotifications
          ? _value.showNotifications
          : showNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {this.concurrentDownloads = 3,
      this.retryCount = 5,
      this.autoResume = true,
      this.showNotifications = true,
      this.themeMode = 'dark'});

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey()
  final int concurrentDownloads;
  @override
  @JsonKey()
  final int retryCount;
  @override
  @JsonKey()
  final bool autoResume;
  @override
  @JsonKey()
  final bool showNotifications;
  @override
  @JsonKey()
  final String themeMode;

  @override
  String toString() {
    return 'AppSettings(concurrentDownloads: $concurrentDownloads, retryCount: $retryCount, autoResume: $autoResume, showNotifications: $showNotifications, themeMode: $themeMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.concurrentDownloads, concurrentDownloads) ||
                other.concurrentDownloads == concurrentDownloads) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.autoResume, autoResume) ||
                other.autoResume == autoResume) &&
            (identical(other.showNotifications, showNotifications) ||
                other.showNotifications == showNotifications) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, concurrentDownloads, retryCount,
      autoResume, showNotifications, themeMode);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {final int concurrentDownloads,
      final int retryCount,
      final bool autoResume,
      final bool showNotifications,
      final String themeMode}) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  int get concurrentDownloads;
  @override
  int get retryCount;
  @override
  bool get autoResume;
  @override
  bool get showNotifications;
  @override
  String get themeMode;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
