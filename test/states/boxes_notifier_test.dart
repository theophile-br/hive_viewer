import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_viewer/services/hive_service.dart';
import 'package:hive_viewer/states/boxes_notifier.dart';
import 'package:mocktail/mocktail.dart';

import '../path_utils.dart';

class MockHiveService extends Mock implements HiveService {}

// Mocks
late HiveService _hiveService;

// Variables
late BoxesNotifier _boxesNotifier;
late String _assetsPath;

void main() {
  _setUpAll();
  _setUp();
  _testBoxesNotifier();
}

void _setUpAll() {
  setUpAll(() {
    _registerFallbacks();

    _assetsPath = getTestAssetsPath();
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
