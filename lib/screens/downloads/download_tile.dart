import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/download_task.dart';
import '../../providers/download_provider.dart';
import '../../core/theme/app_theme.dart';

class DownloadTile extends ConsumerWidget {
  final DownloadTask task;
  const DownloadTile({required this.task, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _getStatusColor(task.status);
    final speedStr = _formatSpeed(task.speed);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassDecoration(brightness: Brightness.dark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.cloud_download, color: CupertinoColors.activeBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.filename,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildActions(context, ref),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: task.progress,
              backgroundColor: const Color(0x33FFFFFF),
              color: statusColor,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(task.progress * 100).toStringAsFixed(1)}% • $speedStr',
                style: const TextStyle(fontSize: 12, color: Color(0x99FFFFFF)),
              ),
              Text(
                task.status.name.toUpperCase(),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
              ),
            ],
          ),
          if (task.eta.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('ETA: ${task.eta}', style: const TextStyle(fontSize: 12, color: Color(0x66FFFFFF))),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (task.status == DownloadStatus.active)
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.pause_fill, size: 20),
            onPressed: () => ref.read(downloadsProvider.notifier).pauseDownload(task.id),
          )
        else if (task.status == DownloadStatus.paused || task.status == DownloadStatus.failed)
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.play_fill, size: 20),
            onPressed: () => ref.read(downloadsProvider.notifier).resumeDownload(task.id),
          ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.xmark_circle, color: CupertinoColors.systemRed, size: 20),
          onPressed: () => ref.read(downloadsProvider.notifier).cancelDownload(task.id),
        ),
      ],
    );
  }

  Color _getStatusColor(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.active: return CupertinoColors.activeBlue;
      case DownloadStatus.completed: return CupertinoColors.activeGreen;
      case DownloadStatus.failed: return CupertinoColors.systemRed;
      case DownloadStatus.paused: return CupertinoColors.systemYellow;
      default: return CupertinoColors.systemGrey;
    }
  }

  String _formatSpeed(double bytesPerSec) {
    if (bytesPerSec <= 0) return "0 B/s";
    const suffixes = ["B/s", "KB/s", "MB/s", "GB/s"];
    var i = 0;
    while (bytesPerSec >= 1024 && i < suffixes.length - 1) {
      bytesPerSec /= 1024;
      i++;
    }
    return "\${bytesPerSec.toStringAsFixed(1)} \${suffixes[i]}";
  }
}

class LinearProgressIndicator extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Color color;
  final double minHeight;

  const LinearProgressIndicator({
    super.key,
    required this.value,
    required this.backgroundColor,
    required this.color,
    this.minHeight = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: minHeight,
      width: double.infinity,
      color: backgroundColor,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(color: color),
      ),
    );
  }
}
