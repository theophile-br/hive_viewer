import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;

/// Service used to open / close boxes and memorize the last
/// opened ones.
class HiveService {
  @visibleForTesting
  set cachedBoxesNames(List<String>? boxesNames) =>
      _cachedBoxesNames = boxesNames;

  List<String>? _cachedBoxesNames;

  final Directory _cacheFolder;

  HiveService({required Directory cacheFolder}) : _cacheFolder = cacheFolder;

  List<String> listBoxesNames() {
    final cachedBoxesNames = _cachedBoxesNames;

    if (cachedBoxesNames == null) {
      throw BoxesNotLoadedException();
    }

    return cachedBoxesNames;
  }

  Future<Box> openBox(String name) async {
    final boxesNames = listBoxesNames();

    if (!boxesNames.contains(name)) {
      throw BoxNotFoundException();
    }

    return Hive.openBox(name);
  }

  Future<void> fetchBoxes(Directory directory) async {
    if (!(await directory.exists())) {
      throw DirectoryNotFoundException();
    }

    final boxesFile = _findHiveBoxes(directory);
    if (boxesFile.isEmpty) {
      throw DirectoryDoesNotContainBoxesException();
    }

    await _copyBoxes(boxesFile);

    Hive.init(_cacheFolder.path);
    _cachedBoxesNames =
        boxesFile.map((file) => p.basenameWithoutExtension(file.path)).toList();
  }

  List<FileSystemEntity> _findHiveBoxes(Directory directory) {
    final directoryContent = directory.listSync();
    return directoryContent
        .where(
          (item) => item is File && item.path.endsWith('.hive'),
        )
        .toList();
  }

  Future<void> _copyBoxes(
    List<FileSystemEntity> boxesFiles,
  ) async {
    await Hive.close();

    await _cacheFolder
        .list(recursive: true, followLinks: false)
        .forEach((item) => item.delete());

    for (final item in boxesFiles) {
      if (item is File) {
        await item.copy(p.join(_cacheFolder.path, p.basename(item.path)));
      }
    }
  }
}

class BoxesNotLoadedException implements Exception {}

class DirectoryNotFoundException implements Exception {}

class DirectoryDoesNotContainBoxesException implements Exception {}

class BoxNotFoundException implements Exception {}
