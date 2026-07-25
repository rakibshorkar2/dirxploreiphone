// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DirectoryItemImpl _$$DirectoryItemImplFromJson(Map<String, dynamic> json) =>
    _$DirectoryItemImpl(
      name: json['name'] as String,
      url: json['url'] as String,
      isDirectory: json['isDirectory'] as bool,
      size: (json['size'] as num?)?.toInt(),
      lastModified: json['lastModified'] == null
          ? null
          : DateTime.parse(json['lastModified'] as String),
    );

Map<String, dynamic> _$$DirectoryItemImplToJson(_$DirectoryItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'isDirectory': instance.isDirectory,
      'size': instance.size,
      'lastModified': instance.lastModified?.toIso8601String(),
    };
