import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive_viewer/services/hive_service.dart';
import 'package:hive_viewer/states/boxes_state.dart';

class BoxesNotifier extends ValueNotifier<BoxesState> {
  final HiveService _hiveService;

  BoxesNotifier({required HiveService hiveService})
      : _hiveService = hiveService,
        super(const BoxesState());

  Future<void> loadBoxesFolder(String path) async {
    final directory = Directory(path);

    await _hiveService.fetchBoxes(directory);
    value = value.copyWith(boxesNames: _hiveService.boxesNames);
  }
}
