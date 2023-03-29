import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:hive/hive.dart';

class HiveFileNotFoundInDirectory extends Error {}

class NotADirectory extends Error {}

class CollectionNameDoesNotExist extends Error {}

class HiveService extends ChangeNotifier {
  List<String> boxesName = [];
  Map<dynamic, dynamic> datas = {};

  HiveService(folder) {
    load(folder);
  }

  void load(folder) {
    Directory directory = Directory(folder);
    if (!directory.existsSync()) {
      throw NotADirectory();
    }
    boxesName = directory
        .listSync()
        .where((file) => file.toString().contains(".hive") && file is File)
        .map((e) => p.basename(e.path).split(".hive")[0])
        .toList();
    if (boxesName.isEmpty) {
      throw HiveFileNotFoundInDirectory();
    }
    Hive.init(directory.path);
    notifyListeners();
  }

  Future<Box> _openBox(String collection) async {
    if (!boxesName.contains(collection)) {
      throw CollectionNameDoesNotExist();
    }
    if (Hive.isBoxOpen(collection)) {
      return Hive.box(collection);
    }
    return Hive.openBox(collection);
  }

  Map<dynamic, dynamic> tryJsonDecode(dynamic object) {
    try {
      return json.decode(object) as Map<dynamic, dynamic>;
    } catch (e) {
      return object;
    }
  }

  Future<Map<dynamic, dynamic>> getAll(String collection) async {
    Box box = await _openBox(collection);
    datas =
        box.toMap().map((key, value) => MapEntry(key, tryJsonDecode(value)));
    notifyListeners();
    return datas;
  }
}
