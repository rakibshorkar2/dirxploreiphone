import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/download_task.dart';
import '../services/download_service.dart';
import '../services/notification_service.dart';

final downloadServiceProvider = Provider((ref) => DownloadService());
final notificationServiceProvider = Provider((ref) => NotificationService());

final downloadsProvider = StateNotifierProvider<DownloadNotifier, List<DownloadTask>>((ref) {
  final service = ref.watch(downloadServiceProvider);
  final notifications = ref.watch(notificationServiceProvider);
  return DownloadNotifier(service, notifications);
});

class DownloadNotifier extends StateNotifier<List<DownloadTask>> {
  final DownloadService _service;
  final NotificationService _notifications;
  DownloadNotifier(this._service, this._notifications) : super([]) {
    _init();
  }

  void _init() {
    _notifications.init();
    _service.downloadProgressStream.listen((data) {
      _handleProgressUpdate(data);
    });
    _refreshActiveDownloads();
  }

  Future<void> _refreshActiveDownloads() async {
    final active = await _service.getActiveDownloads();
    state = active.map((e) => DownloadTask.fromJson(e)).toList();
  }

  void _handleProgressUpdate(Map<String, dynamic> data) {
    final id = data['id'] as String;
    final progress = data['progress'] as double;
    final speed = data['speed'] as double;
    final statusStr = data['status'] as String;
    final downloaded = data['downloadedBytes'] as int;
    final total = data['totalBytes'] as int;
    final eta = data['eta'] as String? ?? '';

    DownloadStatus status;
    switch (statusStr) {
      case 'active': status = DownloadStatus.active; break;
      case 'completed': status = DownloadStatus.completed; break;
      case 'failed': status = DownloadStatus.failed; break;
      case 'paused': status = DownloadStatus.paused; break;
      default: status = DownloadStatus.queued;
    }

    state = [
      for (final task in state)
        if (task.id == id)
          task.copyWith(
            progress: progress,
            speed: speed,
            status: status,
            downloadedBytes: downloaded,
            totalBytes: total,
            eta: eta,
          )
        else task
    ];

    if (status == DownloadStatus.completed) {
      final task = state.firstWhere((t) => t.id == id);
      _notifications.showDownloadComplete(task.filename);
    } else if (status == DownloadStatus.failed) {
       final task = state.firstWhere((t) => t.id == id);
      _notifications.showDownloadFailed(task.filename, data['error'] ?? 'Unknown error');
    }
  }

  Future<void> startDownload(String url, String filename) async {
    // Check if already downloading
    if (state.any((t) => t.url == url && t.status == DownloadStatus.active)) return;

    final id = url.hashCode.toString(); // Simple ID for now
    final newTask = DownloadTask(
      id: id,
      url: url,
      filename: filename,
      status: DownloadStatus.queued,
    );
    state = [...state, newTask];
    await _service.startDownload(url, filename);
  }

  Future<void> pauseDownload(String id) async {
    await _service.pauseDownload(id);
  }

  Future<void> resumeDownload(String id) async {
    await _service.resumeDownload(id);
  }

  Future<void> cancelDownload(String id) async {
    await _service.cancelDownload(id);
    state = state.where((t) => t.id != id).toList();
  }
}
