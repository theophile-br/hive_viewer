import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_viewer/hive_box.dart';

part 'boxes_state.freezed.dart';

@freezed
class BoxesState with _$BoxesState {
  const factory BoxesState({
    List<String>? boxesNames,
    Set<HiveBox>? loadedBoxes,
  }) = _BoxesState;
}
