import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_viewer/hive_box.dart';
import 'package:hive_viewer/hive_item.dart';
import 'package:hive_viewer/services/app_service.dart';
import 'package:hive_viewer/services/hive_service.dart';
import 'package:hive_viewer/states/boxes/boxes_notifier.dart';
import 'package:mocktail/mocktail.dart';

class MockAppService extends Mock implements AppService {}

class MockHiveService extends Mock implements HiveService {}

late AppService _appService;
late HiveService _hiveService;

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
  _appService = MockAppService();
  _hiveService = MockHiveService();

  _stubMocks();
}

void _stubMocks() {
  when(() => _appService.saveBoxesPath(any())).thenAnswer((_) async {});
  when(() => _hiveService.fetchBoxes(any())).thenAnswer((_) async {});
  when(() => _appService.getBoxesPath()).thenReturn('');
}

void _setUpVariables() {
  _boxesNotifier = BoxesNotifier(
    appService: _appService,
    hiveService: _hiveService,
  );
}

void _testBoxesNotifier() {
  _testLoadBoxesFolder();
  _testLoadBoxes();
  _testLoadBox();
}

void _testLoadBoxesFolder() {
  group('loadBoxesFolder(_)', () {
    test('saves the boxes names (in state) and the path (in state and service)',
        () async {
      when(() => _appService.getBoxesPath()).thenReturn('path');
      when(() => _hiveService.boxesNames).thenReturn(['1', '2']);

      await _boxesNotifier.loadBoxesFolder('path');

      verify(() => _hiveService.fetchBoxes(any())).called(1);
      expect(_boxesNotifier.value.boxesNames, ['1', '2']);

      verify(() => _appService.saveBoxesPath('path')).called(1);
      expect(_boxesNotifier.value.boxesPath, 'path');
    });
  });
}

void _testLoadBoxes() {
  group('loadBoxes()', () {
    test('saves the boxes name in the state', () async {
      when(() => _hiveService.boxesNames).thenReturn(['cats', 'dogs', 'test']);

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

      await _boxesNotifier.loadBoxesFolder('');

      expectLater(
        () async => await _boxesNotifier.loadBox('i_do_not_exist'),
        throwsA(isA<BoxNotFoundException>()),
      );
    });

    test('loads the box in the cached list', () async {
      final hiveBox = HiveBox(
        name: 'cats',
        size: 1,
        items: [
          HiveItem(name: 'fluffy', values: {'name': 'Fluffy'}),
        ],
      );
      when(() => _hiveService.boxesNames).thenReturn(['cats']);
      when(() => _hiveService.getHiveBox(any())).thenAnswer(
        (_) async => hiveBox,
      );

      await _boxesNotifier.loadBoxesFolder('');
      await _boxesNotifier.loadBox('cats');

      final loadedBoxes = _boxesNotifier.value.loadedBoxes!;
      expect(loadedBoxes.length, 1);
      expect(loadedBoxes.single, hiveBox);
    });

    test('does not load twice the same box in cache', () async {
      final hiveBox = HiveBox(
        name: 'cats',
        size: 1,
        items: [
          HiveItem(name: 'fluffy', values: {'name': 'Fluffy'}),
        ],
      );
      when(() => _hiveService.boxesNames).thenReturn(['cats']);
      when(() => _hiveService.getHiveBox(any())).thenAnswer(
        (_) async => hiveBox,
      );

      await _boxesNotifier.loadBoxesFolder('');
      await _boxesNotifier.loadBox('cats');
      await _boxesNotifier.loadBox('cats');

      final loadedBoxes = _boxesNotifier.value.loadedBoxes!;
      expect(loadedBoxes.length, 1);
      expect(loadedBoxes.single, hiveBox);
      verify(() => _hiveService.getHiveBox(any())).called(1);
    });

    test('does not store more than 10 elements in cache', () async {
      final boxes = List.generate(
        11,
        (index) => HiveBox(
          name: '$index',
          size: 0,
          items: [],
        ),
      );
      when(() => _hiveService.boxesNames)
          .thenReturn(boxes.map((e) => e.name).toList());

      await _boxesNotifier.loadBoxesFolder('');
      for (final box in boxes.take(10)) {
        when(() => _hiveService.getHiveBox(box.name))
            .thenAnswer((_) async => box);
        await _boxesNotifier.loadBox(box.name);
      }

      when(() => _hiveService.getHiveBox(boxes.last.name)).thenAnswer(
        (_) async => boxes.last,
      );
      await _boxesNotifier.loadBox(boxes.last.name);

      final loadedBoxes = _boxesNotifier.value.loadedBoxes!;
      expect(loadedBoxes.length, 10);
      expect(loadedBoxes.first, boxes[1]);
      expect(loadedBoxes.last, boxes.last);
      verify(() => _hiveService.getHiveBox(any())).called(11);
    });
  });
}
