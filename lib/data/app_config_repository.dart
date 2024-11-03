import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigRepository {
  String? databasePath;
  PackageInfo packageInfo;

  AppConfigRepository({required this.packageInfo});

  String findVersion(){
    return packageInfo.version;
  }

  Future<void> saveDatabasePath(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('database_path', path);
  }

  Future<String?> findDatabasePath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('database_path');
  }

  Future<Directory> getApplicationLocalDirectory()async{
    return getApplicationSupportDirectory();
  }

}