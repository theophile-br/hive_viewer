import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_viewer/hive_box.dart';
import 'package:hive_viewer/hive_item.dart';
import 'package:hive_viewer/services/hive_service.dart';
import 'package:hive_viewer/states/boxes_notifier.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveService extends Mock implements HiveService {}

// Mocks
late HiveService _hiveService;

// Variables
late BoxesNotifier _boxesNotifier;

void main() {
  _setUpAll();
  _setUp();
  _testBoxesNotifier();
}

void _setUpAll() {
  setUpAll(() {
    _registerFallbacks();
  });
}

void _registerFallbacks() {
  registerFallbackValue(Directory(''));
}

void _setUp() {
  setUp(() {
    _setUpMocks();
    _setUpVariables();
  });
}

void _setUpMocks() {
  _hiveService = MockHiveService();
}

void _setUpVariables() {
  _boxesNotifier = BoxesNotifier(hiveService: _hiveService);
}

void _testBoxesNotifier() {
  _testLoadBoxes();
  _testLoadBox();
}

void _testLoadBoxes() {
  group('loadBoxes()', () {
    test('saves the boxes name in the state', () async {
      when(() => _hiveService.boxesNames).thenReturn(['cats', 'dogs', 'test']);
      when(() => _hiveService.fetchBoxes(any())).thenAnswer((_) async {});

      await _boxesNotifier.loadBoxesFolder('');

      expect(
        _boxesNotifier.value.boxesNames,
        ['cats', 'dogs', 'test'],
      );
    });
  });
}

void _testLoadBox() {
  group('loadBox()', () {
    test('throws an exception if there is no boxes', () {
      expectLater(
        () async => await _boxesNotifier.loadBox(''),
        throwsA(isA<BoxesNotLoadedException>()),
      );
    });

    test('throws an exception if the box is missing', () async {
      when(() => _hiveService.boxesNames).thenReturn(['cats', 'dogs', 'test']);
      when(() => _hiveService.fetchBoxes(any())).thenAnswer((_) async {});

      await _boxesNotifier.loadBoxesFolder('');

      expectLater(
        () async => await _boxesNotifier.loadBox('i_do_not_exist'),
        throwsA(isA<BoxNotFoundException>()),
      );
    });

    test('load the box in the cached list', () async {
      final hiveBox = HiveBox(
        name: 'cats',
        size: 1,
        items: [
          HiveItem(name: 'fluffy', values: {'name': 'Fluffy'}),
        ],
      );
      when(() => _hiveService.boxesNames).thenReturn(['cats']);
      when(() => _hiveService.fetchBoxes(any())).thenAnswer((_) async {});
      when(() => _hiveService.getHiveBox(any())).thenAnswer(
        (_) async => hiveBox,
      );

      await _boxesNotifier.loadBoxesFolder('');
      await _boxesNotifier.loadBox('cats');

      final loadedBoxes = _boxesNotifier.value.loadedBoxes;
      expect(loadedBoxes!.length, 1);
      expect(loadedBoxes.single, hiveBox);
    });
  });
}
