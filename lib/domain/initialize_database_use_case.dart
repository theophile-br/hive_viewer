import 'package:hive_viewer/data/app_config_repository.dart';
import 'package:hive_viewer/data/hive_repository.dart';
import 'package:hive_viewer/ui/app_presenter.dart';

class InitializeDatabaseUseCase {
  final AppConfigRepository appConfigRepository;
  final HiveRepository hiveRepository;
  final AppPresenter appPresenter;

  InitializeDatabaseUseCase({
    required this.appConfigRepository,
    required this.hiveRepository,
    required this.appPresenter,
  });

  Future<void> execute(String path) async {
    await hiveRepository.init(databasePath: path);
    final boxesName = await hiveRepository.findCollections();
    appConfigRepository.saveDatabasePath(path);
    appPresenter.present(boxesName: boxesName, databasePath: path);
  }
}
