// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:hive/hive.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

class HiveDataTest {

  static final pathToDatabase = p.join("test_resources","hive_data");
  static final Map<String,Map<String,Object>> data = {
    "cats" : { "fluffy" : {'name': 'Fluffy', 'age': 4}, "loki" : {'name': 'Loki', 'age': 2}},
    "dogs" : { "medor" : {'name': 'Medor', 'age': 4},"youki" : {'name': 'Youki', 'age': 2}},
    "dogsjsonstringify" : { "medor" : jsonEncode({'name': 'Medor', 'age': 4}),"youki" : jsonEncode({'name': 'Youki', 'age': 2})}
  };


  initTestData()async {
    Hive.init(pathToDatabase);
    final catsBox = await Hive.openBox("cats");
    catsBox.clear();
    data["cats"]!.forEach((key, value) async { await catsBox.put(key, value);});
    final dogBox = await Hive.openBox("dogs");
    dogBox.clear();
    data["dogs"]!.forEach((key, value) async { await dogBox.put(key, value);});
    final dogJSONStringifyBox = await Hive.openBox("dogsjsonstringify");
    dogJSONStringifyBox.clear();
    data["dogsjsonstringify"]!.forEach((key, value) async { await dogJSONStringifyBox.put(key, value);});
  }
}
