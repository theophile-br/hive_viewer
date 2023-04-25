import 'dart:convert';
import 'dart:core';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:hive/hive.dart';

class HiveFileNotFoundInDirectory extends Error {}

class NotADirectory extends Error {}

class CollectionNameDoesNotExist extends Error {}

class HiveService extends ChangeNotifier {
  List<String> boxesName = [];
  Map<String, dynamic> currentData = {};
  String currentCollectionName = "";
  int currentDataCount = 0;
  String databasePath = "";

  HiveService(folder) {
    load(folder);
  }

  void refreshDirectory() {
    if (databasePath.isNotEmpty) {
      load(databasePath);
    }
  }

  void refreshCollection() {
    refreshCollection();
    if (currentCollectionName.isNotEmpty) {
      getAll(currentCollectionName);
    }
  }

  void load(folder) async {
    Directory directory = Directory(folder);
    if (!directory.existsSync()) {
      throw NotADirectory();
    }
    databasePath = directory.path;
    boxesName = directory
        .listSync()
        .where((file) => file.toString().contains(".hive") && file is File)
        .map((e) => p.basename(e.path).split(".hive")[0])
        .toList();
    if (boxesName.isEmpty) {
      throw HiveFileNotFoundInDirectory();
    }
    await Hive.deleteFromDisk();
    await Hive.close();
    final appDataDirectory = await getApplicationDocumentsDirectory();
    copyDirectory(directory, appDataDirectory);
    Hive.init(appDataDirectory.path);
    notifyListeners();
  }

  Future<Box> _openBox(String collection) async {
    if (!await Hive.boxExists(collection)) {
      throw CollectionNameDoesNotExist();
    }
    if (Hive.isBoxOpen(collection)) {
      return Hive.box(collection);
    }
    return Hive.openBox(collection);
  }

  Map<dynamic, dynamic> _tryJsonDecode(dynamic object) {
    try {
      return json.decode(object) as Map<dynamic, dynamic>;
    } catch (e) {
      return object;
    }
  }

  Future<Map<dynamic, dynamic>> getAll(String collection) async {
    Box box = await _openBox(collection);
    currentData = box
        .toMap()
        .map((key, value) => MapEntry(key.toString(), _tryJsonDecode(value)));
    currentDataCount = box.length;
    currentCollectionName = collection;
    notifyListeners();
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
