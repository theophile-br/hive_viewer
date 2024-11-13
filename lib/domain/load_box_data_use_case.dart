import 'package:hive_viewer/data/app_config_repository.dart';
import 'package:hive_viewer/data/hive_repository.dart';
import 'package:hive_viewer/domain/types/result_page.dart';
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

  Future<void> execute({required String boxId, String? filter, int pageNumber = 1, int skip = 0}) async {
    final totalDataCount = (await hiveRepository.getData(boxId: boxId)).length;
    final data = await hiveRepository.getData(boxId: boxId, filter: filter);
    const step = 50;
    final dataPaginated = Map.fromEntries(data.entries.skip(pageNumber * step).take((pageNumber * step) + step));
    ResultPage page = ResultPage(
      data: dataPaginated,
      page: pageNumber,
      maxPage: (data.entries.length / step).ceil(),
      pageItemsCount: dataPaginated.entries.length,
      totalItemsCount: data.length
    );
    appPresenter.present(
      page:page,
      currentData: data,
      totalDataCount: totalDataCount,
      selectedBoxName: boxId,
      dataCount: data.length,
    );
  }
}
