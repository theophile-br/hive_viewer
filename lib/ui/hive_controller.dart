import 'package:hive_viewer/domain/app_start_up_use_case.dart';
import 'package:hive_viewer/domain/initialize_database_use_case.dart';
import 'package:hive_viewer/domain/load_box_data_use_case.dart';
import 'package:hive_viewer/domain/load_box_use_case.dart';
import 'package:hive_viewer/ui/app_presenter.dart';

class HiveController{
  final InitializeDatabaseUseCase initializeDatabaseUseCase;
  final LoadBoxDataUseCase loadBoxDataUseCase;
  final LoadBoxUseCase loadBoxUseCase;
  final AppStartUpUseCase appStartUpUseCase;

  HiveController({
    required this.initializeDatabaseUseCase,
    required this.loadBoxDataUseCase,
    required this.loadBoxUseCase,
    required this.appStartUpUseCase,
  });

  Future<void> onAppStartup() async {
    await appStartUpUseCase.execute();
  }

  Future<void> onInitDatabase(String path) async {
    await initializeDatabaseUseCase.execute(path);
  }

  Future<void> onBoxDataLoad({required String boxId, String? filter}) async {
    await loadBoxDataUseCase.execute(boxId: boxId, filter: filter);
  }

  void onRefreshDatabase() async {
    // await initializeDatabaseUseCase.execute(path);
  }

  Future<void> onBoxLoad({String? filter}) async {
      await loadBoxUseCase.execute(filter: filter);
  }
}
