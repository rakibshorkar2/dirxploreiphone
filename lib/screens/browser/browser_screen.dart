import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/directory_provider.dart';
import 'browser_item_tile.dart';
import 'breadcrumb_bar.dart';

class BrowserScreen extends ConsumerWidget {
  const BrowserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final directoryAsync = ref.watch(directoryItemsProvider);
    final urlController = TextEditingController(text: ref.read(currentUrlProvider));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('DirXplore Browser'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => ref.invalidate(directoryItemsProvider),
          child: const Icon(CupertinoIcons.refresh, size: 22),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // URL Input bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CupertinoSearchTextField(
                controller: urlController,
                placeholder: 'Enter Server URL',
                prefixIcon: const Icon(CupertinoIcons.link),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    ref.read(currentUrlProvider.notifier).state = value;
                  }
                },
              ),
            ),
            const BreadcrumbBar(),
            Expanded(
              child: directoryAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(child: Text('No files found or empty directory.'));
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return BrowserItemTile(item: items[index])
                          .animate()
                          .fadeIn(duration: 300.ms, delay: (index * 50).ms)
                          .slideX(begin: 0.1);
                    },
                  );
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.exclamationmark_triangle, color: CupertinoColors.systemRed, size: 48),
                      const SizedBox(height: 16),
                      Text('Error: \$err', textAlign: TextAlign.center),
                      CupertinoButton(
                        child: const Text('Retry'),
                        onPressed: () => ref.invalidate(directoryItemsProvider),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
