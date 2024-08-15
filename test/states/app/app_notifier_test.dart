import 'package:flutter_test/flutter_test.dart';
import 'package:hive_viewer/services/app_service.dart';
import 'package:hive_viewer/states/app/app_notifier.dart';
import 'package:mocktail/mocktail.dart';

class MockAppService extends Mock implements AppService {}

late AppService _appService;

late AppNotifier _appNotifier;

void main() {
  _setUp();
  _testAppNotifier();
}

void _setUp() {
  setUp(() {
    _setUpMocks();
    _setUpVariables();
  });
}

void _setUpMocks() {
  _appService = MockAppService();
}

void _setUpVariables() {
  _appNotifier = AppNotifier(appService: _appService);
}

void _testAppNotifier() {
  _testGetAppVersion();
  _testLoadAppVersion();
}

void _testGetAppVersion() {
  group('get appVersion', () {
    test('returns the app version in the state', () {
      _appNotifier.value = _appNotifier.value.copyWith(appVersion: '1.5');

      expect(_appNotifier.appVersion, '1.5');
    });
  });
}

void _testLoadAppVersion() {
  group('setLoadVersion()', () {
    test('sets the version from the service', () {
      when(() => _appService.getAppVersion()).thenReturn('2.4alpha');
      _appNotifier.loadAppVersion();

      expect(_appNotifier.appVersion, '2.4alpha');
    });

    test('does not set the version if already set', () {
      when(() => _appService.getAppVersion()).thenReturn('2.3beta');
      _appNotifier.loadAppVersion();

      when(() => _appService.getAppVersion()).thenReturn('2.1');
      _appNotifier.loadAppVersion();

      expect(_appNotifier.appVersion, '2.3beta');
      verify(() => _appService.getAppVersion()).called(1);
    });
  });
}
