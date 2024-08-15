import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_viewer/hive_box.dart';
import 'package:hive_viewer/hive_item.dart';
import 'package:path/path.dart' as p;

/// Service used to open / close boxes and memorize the last
/// opened ones.
class HiveService {
  @visibleForTesting
  set cachedBoxesNames(List<String>? boxesNames) =>
      _cachedBoxesNames = boxesNames;

  List<String>? _cachedBoxesNames;
  List<String> get boxesNames {
    final cachedBoxesNames = _cachedBoxesNames;

    if (cachedBoxesNames == null) {
      throw BoxesNotLoadedException();
    }

    return cachedBoxesNames;
  }

  final Directory _cacheFolder;

  HiveService({required Directory cacheFolder}) : _cacheFolder = cacheFolder;

  Future<HiveBox> getHiveBox(String name) async {
    final boxesNames = this.boxesNames;

    if (!boxesNames.contains(name)) {
      throw BoxNotFoundException();
    }

    final box = await Hive.openBox(name);
    final boxSize = box.length;
    final boxItems = _getHiveItems(box);
    box.close();

    return HiveBox(
      name: name,
      size: boxSize,
      items: boxItems,
    );
  }

  List<HiveItem> _getHiveItems(Box box) {
    final List<HiveItem> hiveItems = [];

    box.toMap().forEach(
          (key, value) => hiveItems.add(
            HiveItem(
              name: key.toString(),
              values: jsonDecode(jsonEncode(value)),
            ),
          ),
        );

    return hiveItems;
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
