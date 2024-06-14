import 'dart:convert';
import 'dart:core';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HiveFileNotFoundInDirectory extends Error {}

class NotADirectory extends Error {}

class CollectionNameDoesNotExist extends Error {}

class HiveService extends ChangeNotifier {
  List<String> boxesName = [];
  List<String> filteredBoxesName = [];
  Map<String, Object> currentData = {};
  Map<String, Object> filteredCurrentData = {};
  String currentCollectionName = "";
  int currentDataCount = 0;
  int filteredCurrentDataCount = 0;
  String databasePath = "";

  HiveService(folder) {
    load(folder);
  }

  void boxFiltering(String text) {
    if (text.isEmpty) {
      filteredBoxesName = List.from(boxesName);
    }
    filteredBoxesName = boxesName
        .where((element) => element.toLowerCase().contains(text.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void dataFiltering(String text) {
    if (text.isEmpty) {
      filteredCurrentData = Map.from(currentData);
      filteredCurrentDataCount = filteredCurrentData.entries.length;
    }
    final filtered = currentData.entries
        .where((obj) =>
            jsonEncode(obj.value).toLowerCase().contains(text.toLowerCase()))
        .toList();
    filteredCurrentData = Map.fromEntries(filtered);
    filteredCurrentDataCount = filteredCurrentData.entries.length;
    notifyListeners();
  }

  void refreshDirectory({bool notify = true}) {
    if (databasePath.isNotEmpty) {
      load(databasePath, notify: notify);
    }
  }

  void refreshCollection() {
    refreshDirectory(notify: false);
    if (currentCollectionName.isNotEmpty) {
      getAll(currentCollectionName, notify: false);
    }
    notifyListeners();
  }

  void load(folder, {bool notify = true}) async {
    Directory directory = Directory(folder);
    if (!directory.existsSync()) {
      throw NotADirectory();
    }
    databasePath = directory.absolute.path;
    boxesName = directory
        .listSync()
        .where((file) => file.toString().contains(".hive") && file is File)
        .map((e) => p.basename(e.path).split(".hive")[0])
        .toList();
    if (boxesName.isEmpty) {
      throw HiveFileNotFoundInDirectory();
    }
    filteredBoxesName = List.from(boxesName);
    await Hive.close();
    final Directory appDataDirectory = await getApplicationSupportDirectory();
    appDataDirectory.deleteSync(recursive: true);
    appDataDirectory.createSync(recursive: true);
    copyDirectory(directory, appDataDirectory);
    Hive.init(appDataDirectory.path);
    notify ? notifyListeners() : null;
  }

  Future<Box> _openBox(String collection) async {
    if (!await Hive.boxExists(collection)) {
      throw CollectionNameDoesNotExist();
    }
    // if (Hive.isBoxOpen(collection)) {
    //   return Hive.box(collection);
    // }
    // final encryptionKey =
    //     base64Url.decode("LYPfFqQnD-d2koFC0YqW8frUFTmBKvQmDsdPAnPW4EE=");
    //
    // return Hive.openBox(collection,
    //     encryptionCipher: HiveAesCipher(encryptionKey));
    return Hive.openBox(collection);
  }

  Map<dynamic, dynamic> _tryJsonDecode(dynamic object) {
    try {
      return jsonDecode(object);
    } catch (_) {
      return jsonDecode(jsonEncode(object));
    }
  }

  Future<Map<dynamic, dynamic>> getAll(String collection,
      {bool notify = true}) async {
    Box box = await _openBox(collection);
    currentData = box
        .toMap()
        .map((key, value) => MapEntry(key.toString(), _tryJsonDecode(value)));
    currentDataCount = box.length;
    filteredCurrentData = Map.from(currentData);
    filteredCurrentDataCount = filteredCurrentData.entries.length;
    currentCollectionName = collection;
    await box.close();
    notify ? notifyListeners() : null;
    return currentData;
  }

  void copyDirectory(Directory source, Directory destination) =>
      source.listSync(recursive: false).forEach((var entity) {
        if (entity is Directory) {
          var newDirectory = Directory(
              p.join(destination.absolute.path, p.basename(entity.path)));

          newDirectory.createSync();

          copyDirectory(entity.absolute, newDirectory);
        } else if (entity is File) {
          entity.copySync(p.join(destination.path, p.basename(entity.path)));
        }
      });
}
