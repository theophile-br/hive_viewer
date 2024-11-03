import 'package:hive_viewer/data/app_config_repository.dart';
import 'package:hive_viewer/data/hive_repository.dart';
import 'package:hive_viewer/ui/app_presenter.dart';

class LoadBoxUseCase {
  final AppConfigRepository appConfigRepository;
  final HiveRepository hiveRepository;
  final AppPresenter appPresenter;

  LoadBoxUseCase({
    required this.appConfigRepository,
    required this.hiveRepository,
    required this.appPresenter,
  });

  Future<void> execute({String? filter}) async {
    final totalBoxesCount =
        (await hiveRepository.findCollections(filter: filter)).length;
    final boxesName = await hiveRepository.findCollections(filter: filter);
    appPresenter.present(
      boxesName: boxesName,
      boxesCount: boxesName.length,
      totalBoxesCount: totalBoxesCount,
    );
  }
}
