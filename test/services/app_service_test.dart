import 'package:flutter_test/flutter_test.dart';
import 'package:hive_viewer/services/app_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockPackageInfo extends Mock implements PackageInfo {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

late PackageInfo _packageInfo;
late SharedPreferences _sharedPreferences;

late AppService _appService;

void main() {
  _setUp();
  _testAppService();
}

void _setUp() {
  setUp(() {
    _setUpMocks();
    _setUpVariables();
  });
}

void _setUpMocks() {
  _packageInfo = MockPackageInfo();
  _sharedPreferences = MockSharedPreferences();

  _stubMocks();
}

void _stubMocks() {
  when(() => _sharedPreferences.remove(any())).thenAnswer((_) async => true);
  when(() => _sharedPreferences.setString(any(), any()))
      .thenAnswer((_) async => true);
}

void _setUpVariables() {
  _appService = AppService(
    packageInfo: _packageInfo,
    sharedPreferences: _sharedPreferences,
  );
}

void _testAppService() {
  _testGetAppVersion();
  _testBoxesPath();
}

void _testGetAppVersion() {
  group('getAppVersion()', () {
    test('returns the version of the package', () {
      when(() => _packageInfo.version).thenReturn('1.0.2');

      expect(_appService.getAppVersion(), '1.0.2');
    });
  });
}

void _testBoxesPath() {
  _testGetBoxesPath();
  _testSaveBoxesPath();
}

void _testGetBoxesPath() {
  group('getBoxesPath()', () {
    test('throws an exception if boxes path is not saved', () {
      when(() => _sharedPreferences.get(AppService.boxesPathKey))
          .thenReturn(null);

      expect(
        () => _appService.getBoxesPath(),
        throwsA(isA<PathNotSavedException>()),
      );
    });

    test(
        'throws an exception if path cannot be read and deletes the corrupted data',
        () {
      when(() => _sharedPreferences.get(AppService.boxesPathKey)).thenReturn(3);

      expect(
        () => _appService.getBoxesPath(),
        throwsA(isA<CorruptedDataException>()),
      );
      verify(() => _sharedPreferences.remove(any())).called(1);
    });

    test('returns the path saved in the preferences', () {
      when(() => _sharedPreferences.get(AppService.boxesPathKey))
          .thenReturn('path');

      expect(_appService.getBoxesPath(), 'path');
    });
  });
}

void _testSaveBoxesPath() {
  group('saveBoxesPath(_)', () {
    test('saves the path in the shared preferences', () async {
      await _appService.saveBoxesPath('path');

      verify(
        () => _sharedPreferences.setString(AppService.boxesPathKey, 'path'),
      ).called(1);
    });
  });
}
