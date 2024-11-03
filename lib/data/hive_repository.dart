import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;

class NotADirectory extends Error {}

class HiveFileNotFoundInDirectory extends Error {}

class CollectionNameDoesNotExist extends Error {}

class CollectionEncrypted extends Error {}

class HiveRepository {
  final Directory applicationLocalDirectory;

  HiveRepository({required this.applicationLocalDirectory});

  Future<void> init({required String databasePath}) async {
    Directory directory = Directory(databasePath);
    if (!directory.existsSync()) {
      throw NotADirectory();
    }
    if (await isNotFolderHiveDatabase(directory: directory)) {
      throw HiveFileNotFoundInDirectory();
    }
    await closeDatabase();
    _moveHiveFiles(from: directory, to: applicationLocalDirectory);
    initDatabase(applicationLocalDirectory.path);
  }

  Future<List<String>> _getHiveFiles({required Directory directory}) async {
    return directory
        .listSync()
        .where((file) => file.toString().contains(".hive") && file is File)
        .map((e) => p.basename(e.path).split(".hive")[0])
        .toList();
  }

  Future<bool> isNotFolderHiveDatabase({required Directory directory}) async {
    return (await _getHiveFiles(directory: directory)).isEmpty;
  }

  Future<void> closeDatabase() async {
    await Hive.close();
  }

  Future<void> initDatabase(String path) async {
    Hive.init(path);
  }

  Future<List<String>> findCollections({String? filter}) async {
    final data = await _getHiveFiles(directory: applicationLocalDirectory);
    if (filter != null) {
      return data.where((boxId) => boxId.contains(filter)).toList();
    }
    return data;
  }

  Future<void> _moveHiveFiles({
    required Directory from,
    required Directory to,
  }) async {
    to.deleteSync(recursive: true);
    to.createSync(recursive: true);
    _copyDirectory(from, to);
  }

  Future<Map<String, dynamic>> getData({
    required String boxId,
    String? filter,
  }) async {
    Box box = await _openBox(boxId);
    final currentData = box.toMap().map((key, value) =>
        MapEntry<String, dynamic>(key.toString(), _tryJsonDecode(value)));
    await box.close();
    if (filter != null) {
      return Map.fromEntries(currentData.entries.where(
        (obj) =>
            jsonEncode(obj.value).toLowerCase().contains(filter.toLowerCase()),
      ));
    }
    return currentData;
  }

  Map<dynamic, dynamic> _tryJsonDecode(dynamic object) {
    try {
      return jsonDecode(object);
    } catch (_) {
      return jsonDecode(jsonEncode(object));
    }
  }

  Future<Box> _openBox(String collection) async {
    if (!await Hive.boxExists(collection)) {
      throw CollectionNameDoesNotExist();
    }

    if (!(await Hive.openBox(collection)).isOpen) {
      throw CollectionEncrypted();
      // final encryptionKey =
      //     base64Url.decode("LYPfFqQnD-d2koFC0YqW8frUFTmBKvQmDsdPAnPW4EE=");
      //
      // return Hive.openBox(collection,
      //     encryptionCipher: HiveAesCipher(encryptionKey));
    }
    return Hive.openBox(collection);
  }

  void _copyDirectory(Directory source, Directory destination) =>
      source.listSync(recursive: false).forEach((var entity) {
        if (entity is Directory) {
          var newDirectory = Directory(
              p.join(destination.absolute.path, p.basename(entity.path)));

          newDirectory.createSync();

          _copyDirectory(entity.absolute, newDirectory);
        } else if (entity is File) {
          entity.copySync(p.join(destination.path, p.basename(entity.path)));
        }
      });
}
