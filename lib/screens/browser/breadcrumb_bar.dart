import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/directory_provider.dart';

class BreadcrumbBar extends ConsumerWidget {
  const BreadcrumbBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final crumbs = ref.watch(breadcrumbsProvider);
    final scrollController = ScrollController();

    // Auto-scroll to end when crumbs change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Container(
      height: 44,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x1FFFFFFF), width: 0.5)),
      ),
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: crumbs.length,
        separatorBuilder: (context, index) => const Icon(
          CupertinoIcons.chevron_right,
          size: 14,
          color: Color(0x66FFFFFF),
        ),
        itemBuilder: (context, index) {
          final url = crumbs[index];
          final uri = Uri.parse(url);
          String label = index == 0 ? 'Root' : uri.pathSegments[uri.pathSegments.length - 2];
          if (label.isEmpty) label = 'Root';

          final isLast = index == crumbs.length - 1;

          return CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            onPressed: isLast ? null : () => ref.read(currentUrlProvider.notifier).state = url,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
                color: isLast ? CupertinoColors.white : CupertinoColors.activeBlue,
              ),
            ),
          );
        },
      ),
    );
  }
}
