import 'package:flutter/cupertino.dart';
import 'package:hive_viewer/services/file_service.dart';
import 'package:hive_viewer/states/boxes_state.dart';

/// [ValueNotifier] containing the data related to the boxes
/// that got opened by the user.
class BoxesNotifier extends ValueNotifier<BoxesState> {
  final FileService _fileService;

  BoxesNotifier({required FileService fileService})
      : _fileService = fileService,
        super(BoxesState());
}
