import 'package:flutter/material.dart';
import 'package:hive_viewer/widgets/box_explorer.widget.dart';
import 'package:hive_viewer/widgets/sidesheet.widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: Row(
            children: [SideSheetWidget(), BoxExplorerWidget()],
          ),
        ),
      ],
    );
  }
}
