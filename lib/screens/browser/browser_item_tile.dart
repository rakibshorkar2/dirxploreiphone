import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/directory_item.dart';
import '../../providers/directory_provider.dart';
import '../../providers/download_provider.dart';
import '../../core/theme/app_theme.dart';

class BrowserItemTile extends ConsumerWidget {
  final DirectoryItem item;
  const BrowserItemTile({required this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizeStr = item.size != null ? _formatBytes(item.size!) : '';
    final dateStr = item.lastModified != null ? DateFormat('yyyy-MM-dd HH:mm').format(item.lastModified!) : '';

    return GestureDetector(
      onTap: () {
        if (item.isDirectory) {
          ref.read(currentUrlProvider.notifier).state = item.url;
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: AppTheme.glassDecoration(brightness: Brightness.dark),
        child: Row(
          children: [
            Icon(
              item.isDirectory ? CupertinoIcons.folder_fill : CupertinoIcons.doc_fill,
              color: item.isDirectory ? CupertinoColors.systemYellow : CupertinoColors.systemGrey,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${sizeStr.isNotEmpty ? sizeStr : (item.isDirectory ? "Folder" : "")}${sizeStr.isNotEmpty && dateStr.isNotEmpty ? " • " : ""}$dateStr',
                    style: const TextStyle(fontSize: 12, color: Color(0x99FFFFFF)),
                  ),
                ],
              ),
            ),
            if (!item.isDirectory)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showDownloadAction(context, ref),
                child: const Icon(CupertinoIcons.cloud_download, size: 24),
              ),
            if (item.isDirectory)
              const Icon(CupertinoIcons.chevron_right, size: 16, color: Color(0x33FFFFFF)),
          ],
        ),
      ),
    );
  }

  void _showDownloadAction(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => const CupertinoActionSheet(
        title: Text('Download \$item.name?'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              ref.read(downloadsProvider.notifier).startDownload(item.url, item.name);
              Navigator.pop(context);
            },
            child: const Text('Download'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes.bitLength / 10).floor();
    if (i >= suffixes.length) i = suffixes.length - 1;
    return "\${(bytes / (1 << (10 * i))).toStringAsFixed(1)} \${suffixes[i]}";
  }
}
