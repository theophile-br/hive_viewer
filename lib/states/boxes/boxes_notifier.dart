import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive_viewer/hive_box.dart';
import 'package:hive_viewer/services/app_service.dart';
import 'package:hive_viewer/services/hive_service.dart';
import 'package:hive_viewer/states/boxes/boxes_state.dart';

class BoxesNotifier extends ValueNotifier<BoxesState> {
  final AppService _appService;
  final HiveService _hiveService;

  BoxesNotifier({
    required AppService appService,
    required HiveService hiveService,
  })  : _appService = appService,
        _hiveService = hiveService,
        super(const BoxesState());

  Future<void> init() async {}

  Future<void> reloadBoxes() async {}

  Future<void> loadBoxesFolder(String path) async {
    final directory = Directory(path);

    await _hiveService.fetchBoxes(directory);
    await _appService.saveBoxesPath(directory.path);

    value = value.copyWith(
      boxesNames: _hiveService.boxesNames,
      boxesPath: _appService.getBoxesPath(),
    );
  }

  Future<void> loadBox(String name) async {
    final boxesNames = value.boxesNames;

    if (boxesNames == null) {
      throw BoxesNotLoadedException();
    }

    if (!boxesNames.contains(name)) {
      throw BoxNotFoundException();
    }

    Set<HiveBox> loadedBoxes = value.loadedBoxes ?? {};
    if (loadedBoxes.any((box) => box.name == name)) {
      return;
    }

    if (loadedBoxes.length == 10) {
      loadedBoxes = loadedBoxes.toList().sublist(1, 10).toSet();
    }

    value = value.copyWith(
      loadedBoxes: {
        ...loadedBoxes,
        await _hiveService.getHiveBox(name),
      },
    );
  }
}
