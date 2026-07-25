import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/file_service.dart';

final fileServiceProvider = Provider((ref) => FileService());

final currentFileRelativePathProvider = StateProvider<String?>((ref) => null);

final localFilesProvider = FutureProvider<List<FileSystemEntity>>((ref) async {
  final service = ref.watch(fileServiceProvider);
  final relPath = ref.watch(currentFileRelativePathProvider);
  return await service.listFiles(relativePath: relPath);
});

final fileOperationsProvider = Provider((ref) {
  final service = ref.watch(fileServiceProvider);
  return FileOperations(service, ref);
});

class FileOperations {
  final FileService _service;
  final Ref _ref;
  FileOperations(this._service, this._ref);

  Future<void> createFolder(String name) async {
    final relPath = _ref.read(currentFileRelativePathProvider);
    await _service.createFolder(name, relativePath: relPath);
    _ref.invalidate(localFilesProvider);
  }

  Future<void> deleteEntity(String fullPath) async {
    await _service.deleteEntity(fullPath);
    _ref.invalidate(localFilesProvider);
  }

  Future<void> renameEntity(String oldPath, String newName) async {
    await _service.renameEntity(oldPath, newName);
    _ref.invalidate(localFilesProvider);
  }
}
