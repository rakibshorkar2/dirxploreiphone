import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/download_provider.dart';
import 'download_tile.dart';

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloads = ref.watch(downloadsProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Downloads'),
      ),
      child: SafeArea(
        child: downloads.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.cloud_download, size: 64, color: Color(0x33FFFFFF)),
                    SizedBox(height: 16),
                    Text('No downloads yet.', style: TextStyle(color: Color(0x66FFFFFF))),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 12),
                itemCount: downloads.length,
                itemBuilder: (context, index) => DownloadTile(task: downloads[index]),
              ),
      ),
    );
  }
}
