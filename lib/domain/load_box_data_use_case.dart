import 'package:hive_viewer/data/app_config_repository.dart';
import 'package:hive_viewer/data/hive_repository.dart';
import 'package:hive_viewer/ui/app_presenter.dart';

class LoadBoxDataUseCase {
  final AppConfigRepository appConfigRepository;
  final HiveRepository hiveRepository;
  final AppPresenter appPresenter;

  LoadBoxDataUseCase({
    required this.appConfigRepository,
    required this.hiveRepository,
    required this.appPresenter,
  });

  Future<void> execute({required String boxId, String? filter}) async {
    final totalDataCount = (await hiveRepository.getData(boxId: boxId)).length;
    final data = await hiveRepository.getData(boxId: boxId, filter: filter);
    appPresenter.present(
      currentData: data,
      totalDataCount: totalDataCount,
      selectedBoxName: boxId,
      dataCount: data.length,
    );
  }
}
