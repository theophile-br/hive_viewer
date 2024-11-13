import 'package:hive_viewer/data/app_config_repository.dart';
import 'package:hive_viewer/domain/initialize_database_use_case.dart';
import 'package:hive_viewer/ui/app_presenter.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

class AppStartUpUseCase {
  final AppConfigRepository appConfigRepository;
  final AppPresenter appPresenter;
  final InitializeDatabaseUseCase initializeDatabaseUseCase;

  AppStartUpUseCase({
    required this.appConfigRepository,
    required this.appPresenter,
    required this.initializeDatabaseUseCase,
  });

  Future<void> execute() async {
    final appVersion = appConfigRepository.findVersion();
    appPresenter.present(appVersion: appVersion);
    String? appDataBase = await appConfigRepository.findDatabasePath();
    appDataBase ??= p.join("test_resources", "hive_data");
    await initializeDatabaseUseCase.execute(appDataBase);
  }
}