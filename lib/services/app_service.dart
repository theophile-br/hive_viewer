import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  static const String boxesPathKey = 'BOXES_PATH';

  final PackageInfo _packageInfo;
  final SharedPreferences _sharedPreferences;

  AppService({
    required PackageInfo packageInfo,
    required SharedPreferences sharedPreferences,
  })  : _packageInfo = packageInfo,
        _sharedPreferences = sharedPreferences;

  String getAppVersion() {
    return _packageInfo.version;
  }

  Future<void> saveBoxesPath(String path) async {
    await _sharedPreferences.setString(AppService.boxesPathKey, path);
  }

  String getBoxesPath() {
    final boxesPath = _sharedPreferences.get(AppService.boxesPathKey);
    if (boxesPath == null) {
      throw PathNotSavedException();
    }

    if (boxesPath is! String) {
      _sharedPreferences.remove(AppService.boxesPathKey);
      throw CorruptedDataException();
    }

    return boxesPath;
  }
}

class PathNotSavedException implements Exception {}

class CorruptedDataException implements Exception {}
