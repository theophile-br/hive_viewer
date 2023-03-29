import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:hive_viewer/services/hive.service.dart';
import 'package:hive_viewer/widgets/header.widget.dart';
import 'package:provider/provider.dart';

class SideSheetWidget extends StatelessWidget {
  const SideSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> boxesName = context.select(
      (HiveService value) => value.boxesName,
    );

    return Container(
      width: 200,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => null,
              ),
              Text("<nombre de box>"),
              Text("Boxes"),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: boxesName.length,
              itemBuilder: (context, index) {
                final item = boxesName[index];
                return GestureDetector(
                  child: Text(item),
                  onTap: () => context.read<HiveService>().getAll(item),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
