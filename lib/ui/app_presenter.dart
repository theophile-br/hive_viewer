import 'package:hive_viewer/domain/types/result_page.dart';
import 'package:hive_viewer/ui/app_view_model.dart';

class AppPresenter {
  final AppViewModel appViewModel;

  AppPresenter(this.appViewModel);

  void present({
    ResultPage? page,
    List<String>? boxesName,
    String? selectedBoxName,
    int? totalBoxesCount,
    int? boxesCount,
    Map<String, dynamic>? currentData,
    int? totalDataCount,
    int? dataCount,
    String? databasePath,
    String? appVersion,
  }) {
    appViewModel.updateAppViewModel(
      page: page,
      boxesName: boxesName,
      currentData: currentData,
      selectedBoxName: selectedBoxName,
      totalDataCount: totalDataCount,
      dataCount: dataCount,
      databasePath: databasePath,
      appVersion: appVersion,
      totalBoxesCount : totalBoxesCount,
      boxesCount : boxesCount,
    );
  }
}
