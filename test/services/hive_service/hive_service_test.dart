import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_viewer/services/hive_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

class TestBox extends Mock implements Box {}

late HiveService _hiveService;
late String _assetsPath;

void main() {
  _setUpAll();
  _setUp();
  _testHiveService();
}

void _setUpAll() {
  setUpAll(() {
    _assetsPath = p.join('test', 'services', 'hive_service', 'assets');
  });
}

void _setUp() {
  setUp(() {
    _hiveService = HiveService(
      cacheFolder: Directory(
        p.join('test', 'services', 'hive_service', 'test_cache'),
      ),
    );
  });
}

void _testHiveService() {
  _testListBoxes();
  _testFetchBoxes();
  _testOpenBox();
}

void _testListBoxes() {
  group('listBoxes()', () {
    test('throws an exception if no boxes are loaded', () {
      _hiveService.cachedBoxesNames = null;

      expect(
        () => _hiveService.listBoxesNames(),
        throwsA(isA<BoxesNotLoadedException>()),
      );
    });

    test('returns the list of boxes names loaded', () {
      _hiveService.cachedBoxesNames = ['1', '2'];
      expect(_hiveService.listBoxesNames(), ['1', '2']);
    });
  });
}

void _testFetchBoxes() {
  group('fetchBoxes(_)', () {
    test('throws an exception if the directory does not exist', () {
      final nonExistingDirectory = Directory('i_do_not_exist/');

      expect(
        () => _hiveService.fetchBoxes(nonExistingDirectory),
        throwsA(isA<DirectoryNotFoundException>()),
      );
    });

    test('throws an exception if no boxes are found in the app', () {
      final emptyDirectory = Directory(p.join(_assetsPath, 'empty_folder'));

      expect(
        () => _hiveService.fetchBoxes(emptyDirectory),
        throwsA(isA<DirectoryDoesNotContainBoxesException>()),
      );
    });

    test('loads boxes in the app', () async {
      final boxesDirectory = Directory(p.join(_assetsPath, 'boxes'));
      await _hiveService.fetchBoxes(boxesDirectory);

      final boxesNames = _hiveService.listBoxesNames();
      expect(boxesNames.length, 3);
      expect(boxesNames[0], 'cats');
      expect(boxesNames[1], 'dogs');
      expect(boxesNames[2], 'dogsjsonstringify');
    });
  });
}

void _testOpenBox() {
  group('openBox()', () {
    test('throws an exception if no boxes are loaded', () async {
      _hiveService.cachedBoxesNames = null;
      expectLater(
        () async => await _hiveService.openBox('i_do_not_exist'),
        throwsA(isA<BoxesNotLoadedException>()),
      );
    });

    test('throws an exception if the box is not found', () async {
      _hiveService.cachedBoxesNames = ['test'];
      expectLater(
        () async => await _hiveService.openBox('i_do_not_exist'),
        throwsA(isA<BoxNotFoundException>()),
      );
    });

    test('can open a hive box', () async {
      await _hiveService.fetchBoxes(Directory(p.join(_assetsPath, 'boxes')));

      final box = await _hiveService.openBox('cats');
      expect(box, isA<Box>());
    });

    group(
      'encrypted boxes',
      () {
        test('can open an encrypted hive box', () {
          expect(false, isTrue);
        });

        test('throws an exception if encryption key is incorrect', () {
          expect(false, isTrue);
        });
      },
      skip: true,
    );
  });
}
