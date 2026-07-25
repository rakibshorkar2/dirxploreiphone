import 'dart:async';
import 'package:flutter/services.dart';
import '../core/constants/app_constants.dart';
import '../models/download_task.dart';

class DownloadService {
  final MethodChannel _channel = const MethodChannel(AppConstants.downloadsChannel);
  final EventChannel _eventChannel = const EventChannel(AppConstants.downloadsEventChannel);

  Stream<Map<String, dynamic>> get downloadProgressStream {
    return _eventChannel.receiveBroadcastStream().map((event) => Map<String, dynamic>.from(event));
  }

  Future<void> startDownload(String url, String filename) async {
    try {
      await _channel.invokeMethod('startDownload', {
        'url': url,
        'filename': filename,
      });
    } on PlatformException catch (e) {
      print("Failed to start download: \${e.message}");
      rethrow;
    }
  }

  Future<void> pauseDownload(String id) async {
    await _channel.invokeMethod('pauseDownload', {'id': id});
  }

  Future<void> resumeDownload(String id) async {
    await _channel.invokeMethod('resumeDownload', {'id': id});
  }

  Future<void> cancelDownload(String id) async {
    await _channel.invokeMethod('cancelDownload', {'id': id});
  }

  Future<List<Map<String, dynamic>>> getActiveDownloads() async {
    final List<dynamic>? result = await _channel.invokeMethod('getActiveDownloads');
    if (result == null) return [];
    return result.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
