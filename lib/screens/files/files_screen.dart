import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import '../../providers/file_provider.dart';
import '../../core/theme/app_theme.dart';

class FilesScreen extends ConsumerWidget {
  const FilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filesAsync = ref.watch(localFilesProvider);
    final currentRelPath = ref.watch(currentFileRelativePathProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(currentRelPath == null ? 'Files' : p.basename(currentRelPath)),
        leading: currentRelPath != null
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.back),
                onPressed: () {
                  final parent = p.dirname(currentRelPath);
                  ref.read(currentFileRelativePathProvider.notifier).state = parent == '.' ? null : parent;
                },
              )
            : null,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.folder_badge_plus),
          onPressed: () => _showCreateFolderDialog(context, ref),
        ),
      ),
      child: SafeArea(
        child: filesAsync.when(
          data: (entities) {
            if (entities.isEmpty) {
              return const Center(child: Text('Empty folder', style: TextStyle(color: Color(0x66FFFFFF))));
            }
            return ListView.builder(
              itemCount: entities.length,
              itemBuilder: (context, index) {
                final entity = entities[index];
                final isDir = entity is Directory;
                final name = p.basename(entity.path);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: AppTheme.glassDecoration(brightness: Brightness.dark),
                  child: CupertinoListTile(
                    leading: Icon(
                      isDir ? CupertinoIcons.folder_fill : CupertinoIcons.doc_fill,
                      color: isDir ? CupertinoColors.systemYellow : CupertinoColors.systemGrey,
                    ),
                    title: Text(name),
                    trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.ellipsis, size: 20),
                      onPressed: () => _showFileActions(context, ref, entity),
                    ),
                    onTap: () {
                      if (isDir) {
                        final rel = currentRelPath == null ? name : p.join(currentRelPath, name);
                        ref.read(currentFileRelativePathProvider.notifier).state = rel;
                      } else {
                        OpenFilex.open(entity.path);
                      }
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, s) => Center(child: Text('Error: \$e')),
        ),
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showCupertinoDialog(
      context: context,
      builder: (context) => const CupertinoAlertDialog(
        title: Text('New Folder'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: CupertinoTextField(controller: controller, placeholder: 'Folder Name'),
        ),
        actions: [
          CupertinoDialogAction(child: const Text('Cancel'), onPressed: () => Navigator.pop(context)),
          CupertinoDialogAction(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(fileOperationsProvider).createFolder(controller.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showFileActions(BuildContext context, WidgetRef ref, FileSystemEntity entity) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(p.basename(entity.path)),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Share.shareXFiles([XFile(entity.path)]);
              Navigator.pop(context);
            },
            child: const Text('Share'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              ref.read(fileOperationsProvider).deleteEntity(entity.path);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
