import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppService extends ChangeNotifier {
  PackageInfo packageInfo;

  AppService({required this.packageInfo});
}
