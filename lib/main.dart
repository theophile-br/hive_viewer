import 'package:flutter/material.dart';
import 'package:hive_viewer/data/app_config_repository.dart';
import 'package:hive_viewer/data/hive_repository.dart';
import 'package:hive_viewer/domain/initialize_database_use_case.dart';
import 'package:hive_viewer/domain/load_box_data_use_case.dart';
import 'package:hive_viewer/domain/load_box_use_case.dart';
import 'package:hive_viewer/ui/app_presenter.dart';
import 'package:hive_viewer/ui/app_view_model.dart';
import 'package:hive_viewer/ui/hive_controller.dart';
import 'package:hive_viewer/widgets/home.widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'domain/app_start_up_use_case.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // DEP INJECTION
  final appConfigRepository =
      AppConfigRepository(packageInfo: await PackageInfo.fromPlatform());
  final hiveRepository = HiveRepository(
      applicationLocalDirectory: await getApplicationSupportDirectory());

  final appViewModel = AppViewModel();

  final appPresenter = AppPresenter(appViewModel);

  final loadBoxDataUseCase = LoadBoxDataUseCase(
    appConfigRepository: appConfigRepository,
    hiveRepository: hiveRepository,
    appPresenter: appPresenter,
  );

  final loadBoxUseCase = LoadBoxUseCase(
    appConfigRepository: appConfigRepository,
    hiveRepository: hiveRepository,
    appPresenter: appPresenter,
  );

  final initializeDatabaseUseCase = InitializeDatabaseUseCase(
    appConfigRepository: appConfigRepository,
    hiveRepository: hiveRepository,
    appPresenter: appPresenter,
  );

  final appStartUpUseCase = AppStartUpUseCase(
    appConfigRepository: appConfigRepository,
    appPresenter: appPresenter,
    initializeDatabaseUseCase: initializeDatabaseUseCase,
  );

  final hiveController = HiveController(
      loadBoxDataUseCase: loadBoxDataUseCase,
      initializeDatabaseUseCase: initializeDatabaseUseCase,
      loadBoxUseCase: loadBoxUseCase,
      appStartUpUseCase: appStartUpUseCase);

  await appStartUpUseCase.execute();

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => hiveController,
        ),
        ChangeNotifierProvider(
          create: (_) => appViewModel,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hive Viewer',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: HomeView()),
    );
  }
}
