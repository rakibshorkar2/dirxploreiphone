import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_task.freezed.dart';
part 'download_task.g.dart';

enum DownloadStatus {
  queued,
  active,
  paused,
  completed,
  failed,
  cancelled
}

@freezed
class DownloadTask with _$DownloadTask {
  const factory DownloadTask({
    required String id,
    required String url,
    required String filename,
    required DownloadStatus status,
    @Default(0.0) double progress,
    @Default(0.0) double speed, // bytes per second
    @Default('') String eta,
    @Default(0) int downloadedBytes,
    @Default(0) int totalBytes,
    String? errorMessage,
  }) = _DownloadTask;

  factory DownloadTask.fromJson(Map<String, dynamic> json) => _$DownloadTaskFromJson(json);
}
