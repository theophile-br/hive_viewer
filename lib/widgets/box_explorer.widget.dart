import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:hive/hive.dart';
import 'package:hive_viewer/services/hive.service.dart';
import 'package:provider/provider.dart';

class BoxExplorerWidget extends StatelessWidget {
  const BoxExplorerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final d = context.select(
      (HiveService value) => value.currentData,
    );

    final datas = jsonEncode(d);

    final currentDataCount = context.select(
      (HiveService value) => value.currentDataCount,
    );

    final currentBoxName = context.select(
      (HiveService value) => value.currentCollectionName,
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Column(
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Text("HiveViewer 1.0.0"),
                ),
              ],
            ),
            // Row(
            //   children: [
            //     Text("<input field>"),
            //     ElevatedButton(onPressed: () => null, child: Text("Apply"))
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      currentBoxName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(" - "),
                    Text(
                      currentDataCount.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(" document${currentDataCount != 0 ? "s" : ""}")
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: () =>
                          context.read<HiveService>().refreshCollection(),
                      child: Row(
                        children: const [Icon(Icons.refresh), Text("Refresh")],
                      )),
                )
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: JsonViewer(jsonDecode(datas)))),
          ],
        ),
      ),
    );
  }
}
