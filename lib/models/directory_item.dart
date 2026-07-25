import 'package:freezed_annotation/freezed_annotation.dart';

part 'directory_item.freezed.dart';
part 'directory_item.g.dart';

@freezed
class DirectoryItem with _$DirectoryItem {
  const factory DirectoryItem({
    required String name,
    required String url,
    required bool isDirectory,
    int? size,
    DateTime? lastModified,
  }) = _DirectoryItem;

  factory DirectoryItem.fromJson(Map<String, dynamic> json) => _$DirectoryItemFromJson(json);
}
