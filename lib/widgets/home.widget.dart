import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:hive_viewer/services/hive.service.dart';
import 'package:hive_viewer/widgets/box_explorer.widget.dart';
import 'package:hive_viewer/widgets/sidesheet.widget.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [SideSheetWidget(), BoxExplorerWidget()],
          ),
        )
      ],
    );
  }
}
