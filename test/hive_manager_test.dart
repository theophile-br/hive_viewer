import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../test_resources/hive_data_test.dart';

void main() {

group("HiveManager Class Unit Test", () {

  setUp(() async {
    await HiveDataTest().initTestData();
  });
  //
  // test("Should throw an error if you provide path doesn't exist", () => {
  //   expect(() => HiveService("not a directory"), throwsA(isA<NotADirectory>()))
  // });
  //
  // test("Should throw an error if you provide a file", () {
  //   final pathToDatabase = p.join("test_resources","hive_data_generator.dart");
  //   expect(() => HiveService(pathToDatabase), throwsA(isA<NotADirectory>()));
  // });
  //
  // test("Should throw an error if the folder doesn't contain hive files", () {
  //   final pathToDatabase = p.join("test_resources","no_hive_data");
  //   expect(() => HiveService(pathToDatabase), throwsA(isA<HiveFileNotFoundInDirectory>()));
  // });
  //
  // test("Should open a folder And load box name", () async {
  //   final pathToDatabase = p.join("test_resources","hive_data");
  //   final hiveManager = HiveService(pathToDatabase);
  //   expect(hiveManager.boxesName[0], "cats");
  //   expect(hiveManager.boxesName[1], "dogs");
  //   expect(hiveManager.boxesName[2], "dogsjsonstringify");
  // });
  //
  //   test("Should open a folder And load box name", () async {
  //   final pathToDatabase = p.join("test_resources","hive_data");
  //   final hiveManager = HiveService(pathToDatabase);
  //   expect(() => HiveService(pathToDatabase).getAll("dontexist"), throwsA(isA<CollectionNameDoesNotExist>()));
  // });
  //
  // test("Should open a hive file and read data", () async {
  //   final pathToDatabase = p.join("test_resources","hive_data");
  //   final hiveManager = HiveService(pathToDatabase);
  //   Map<dynamic, dynamic> cats = await hiveManager.getAll("cats");
  //   MapEntry<dynamic, dynamic> cat = cats.entries.first;
  //   expect(cat.key, "fluffy");
  //   expect(cat.value["name"], "Fluffy");
  //   expect(cat.value["age"], 4);
  // });
  //
  // test("Should open a hive file and read json stringify data by converting it", ()  async {
  //   final pathToDatabase = p.join("test_resources","hive_data");
  //   final hiveManager = HiveService(pathToDatabase);
  //   Map<dynamic, dynamic> dogs = await hiveManager.getAll("dogsjsonstringify");
  //   MapEntry<dynamic, dynamic> dog = dogs.entries.first;
  //   expect(dog.key, "medor");
  //   expect(dog.value["name"], "Medor");
  //   expect(dog.value["age"], 4);
  // });

});

}