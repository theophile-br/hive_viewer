import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:hive/hive.dart';
import 'package:hive_viewer/services/hive.service.dart';
import 'package:hive_viewer/services/app.service.dart';
import 'package:provider/provider.dart';

class BoxExplorerWidget extends StatelessWidget {
  const BoxExplorerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final datas = context.select(
      (HiveService value) => value.currentData,
    );

    final currentDataCount = context.select(
      (HiveService value) => value.currentDataCount,
    );

    final currentBoxName = context.select(
      (HiveService value) => value.currentCollectionName,
    );

    final version = context.read<AppService>().packageInfo.version;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Column(
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    "HiveViewer $version",
                    style:
                        const TextStyle(color: Color.fromRGBO(33, 42, 62, 1)),
                  ),
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
                      currentBoxName.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(57, 72, 103, 1)),
                    ),
                    const Text(" - "),
                    Text(
                      currentDataCount.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(33, 42, 62, 1)),
                    ),
                    Text(
                      " document${currentDataCount != 0 ? "s" : ""}",
                      style:
                          const TextStyle(color: Color.fromRGBO(33, 42, 62, 1)),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(33, 42, 62, 1),
                      ),
                      onPressed: () =>
                          context.read<HiveService>().refreshCollection(),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.refresh,
                          ),
                          Text("Refresh")
                        ],
                      )),
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: datas.entries.length,
                  itemBuilder: (context, index) => JsonViewer(Map.fromEntries({
                    datas.entries.elementAt(index),
                  })),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
