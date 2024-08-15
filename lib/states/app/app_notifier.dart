import 'package:flutter/cupertino.dart';
import 'package:hive_viewer/services/app_service.dart';
import 'package:hive_viewer/states/app/app_state.dart';

class AppNotifier extends ValueNotifier<AppState> {
  final AppService _appService;

  AppNotifier({required AppService appService})
      : _appService = appService,
        super(const AppState());

  String? get appVersion => value.appVersion;

  void loadAppVersion() {
    if (value.appVersion == null) {
      value = value.copyWith(appVersion: _appService.getAppVersion());
    }
  }
}
