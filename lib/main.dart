import 'package:flutter/material.dart';
import 'package:hive_viewer/services/app.service.dart';
import 'package:hive_viewer/services/hive.service.dart';
import 'package:hive_viewer/widgets/home.widget.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppService(packageInfo: packageInfo),
        ),
        ChangeNotifierProvider(
          create: (_) => HiveService(p.join("test_resources", "hive_data")),
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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: HomeView()),
    );
  }
}
