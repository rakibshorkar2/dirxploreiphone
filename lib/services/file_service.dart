import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileService {
  Future<Directory> get documentsDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  Future<List<FileSystemEntity>> listFiles({String? relativePath}) async {
    final docsDir = await documentsDirectory;
    final targetPath = relativePath != null ? p.join(docsDir.path, relativePath) : docsDir.path;
    final dir = Directory(targetPath);
    if (!await dir.exists()) return [];
    return dir.listSync();
  }

  Future<Directory> createFolder(String name, {String? relativePath}) async {
    final docsDir = await documentsDirectory;
    final targetPath = relativePath != null ? p.join(docsDir.path, relativePath, name) : p.join(docsDir.path, name);
    final dir = Directory(targetPath);
    return await dir.create(recursive: true);
  }

  Future<void> deleteEntity(String fullPath) async {
    if (fullPath.contains('..')) throw SecurityException('Path traversal detected');
    final file = File(fullPath);
    if (await file.exists()) {
      await file.delete();
      return;
    }
    final dir = Directory(fullPath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  Future<void> renameEntity(String oldPath, String newName) async {
    if (oldPath.contains('..') || newName.contains('/') || newName.contains('\\')) {
      throw SecurityException('Invalid characters or path traversal detected');
    }
    final parentDir = p.dirname(oldPath);
    final newPath = p.join(parentDir, newName);

    final file = File(oldPath);
    if (await file.exists()) {
      await file.rename(newPath);
      return;
    }
    final dir = Directory(oldPath);
    if (await dir.exists()) {
      await dir.rename(newPath);
    }
  }

  Future<void> moveEntity(String sourcePath, String targetRelativeDir) async {
    final docsDir = await documentsDirectory;
    final destDir = p.join(docsDir.path, targetRelativeDir);
    final name = p.basename(sourcePath);
    final destPath = p.join(destDir, name);

    final file = File(sourcePath);
    if (await file.exists()) {
      await file.rename(destPath);
      return;
    }
    final dir = Directory(sourcePath);
    if (await dir.exists()) {
      await dir.rename(destPath);
    }
  }
}

class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);
  @override
  String toString() => 'SecurityException: $message';
}
