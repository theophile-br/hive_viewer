import 'package:flutter/cupertino.dart';
import 'package:hive_viewer/domain/types/result_page.dart';

class AppViewModel extends ChangeNotifier {
  List<String> boxesName = [];
  int? totalBoxesCount;
  int? boxesCount;
  ResultPage page = ResultPage.empty();
  Map<String, dynamic> data = {};
  String selectedBoxName = "";
  int totalDataCount = 0;
  int dataCount = 0;
  String collectionSearchString = "";
  String databasePath = "";

  String get databasePathForDisplay =>
      '...${databasePath.substring(databasePath.length - 20, databasePath.length)}';
  String appVersion = "0.0";

  AppViewModel();

  Future<void> updateAppViewModel({
    ResultPage? page,
    List<String>? boxesName,
    Map<String, dynamic>? currentData,
    Map<String, dynamic>? filteredCurrentData,
    String? selectedBoxName,
    int? totalDataCount,
    int? dataCount,
    String? collectionSearchString,
    String? databasePath,
    String? appVersion,
    int? totalBoxesCount,
    int? boxesCount,
  }) async {
    this.boxesName = boxesName ?? this.boxesName;
    this.page = page ?? this.page;
    data = currentData ?? data;
    this.selectedBoxName = selectedBoxName ?? this.selectedBoxName;
    this.totalDataCount = totalDataCount ?? this.totalDataCount;
    this.dataCount = dataCount ?? this.dataCount;
    this.collectionSearchString =
        collectionSearchString ?? this.collectionSearchString;
    this.databasePath = databasePath ?? this.databasePath;
    this.appVersion = appVersion ?? this.appVersion;
    this.totalBoxesCount = totalBoxesCount ?? this.totalBoxesCount;
    this.boxesCount = boxesCount ?? this.boxesCount;
    notifyListeners();
  }
}
