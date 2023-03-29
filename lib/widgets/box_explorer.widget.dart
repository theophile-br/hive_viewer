import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:hive_viewer/services/hive.service.dart';
import 'package:hive_viewer/widgets/header.widget.dart';
import 'package:provider/provider.dart';

class BoxExplorerWidget extends StatelessWidget {
  const BoxExplorerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final datas = jsonEncode(context.select(
      (HiveService value) => value.datas,
    ));

    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Text("<input field>"),
              ElevatedButton(onPressed: () => null, child: Text("Apply"))
            ],
          ),
          Row(
            children: [
              Text("<number of data>"),
              ElevatedButton(
                  onPressed: () => null, child: Text("<icon> Refresh"))
            ],
          ),
          Expanded(
              child: datas.isEmpty
                  ? Text("No data to show")
                  : JsonViewer(jsonDecode(datas))),
        ],
      ),
    );
  }
}
