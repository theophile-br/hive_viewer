import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_viewer/ui/app_view_model.dart';
import 'package:hive_viewer/ui/hive_controller.dart';
import 'package:provider/provider.dart';

import '../json_viewer.dart';

class BoxExplorerWidget extends StatelessWidget {
  const BoxExplorerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.select(
      (AppViewModel value) => value.data,
    );

    final currentDataCount = context.select(
      (AppViewModel value) => value.totalDataCount,
    );

    final currentBoxName = context.select(
      (AppViewModel value) => value.selectedBoxName,
    );

    final version = context.select(
      (AppViewModel value) => value.appVersion,
    );

    return Expanded(
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  "HiveViewer $version",
                  style: const TextStyle(color: Color.fromRGBO(33, 42, 62, 1)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      currentBoxName.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(57, 72, 103, 1)),
                    ),
                  ),
                  const Text(
                    " - ",
                    style:
                        const TextStyle(color: Color.fromRGBO(33, 42, 62, 1)),
                  ),
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
                  ),
                  if (currentDataCount != 0) ...[
                    const Text(
                      "( ",
                      style:
                          const TextStyle(color: Color.fromRGBO(33, 42, 62, 1)),
                    ),
                    Text(
                      currentDataCount.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(33, 42, 62, 1)),
                    ),
                    const Text(
                      " filtered )",
                      style:
                          const TextStyle(color: Color.fromRGBO(33, 42, 62, 1)),
                    ),
                  ],
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        // primary: Color.fromRGBO(33, 42, 62, 1),
                        ),
                    onPressed: () =>
                        context.read<HiveController>().onRefreshDatabase(),
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
          TextField(
            onChanged: (text) {
              context.read<HiveController>().onBoxDataLoad(
                    boxId: currentBoxName,
                    filter: text,
                  );
            },
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(33, 42, 62, 1)),
            decoration: const InputDecoration(
                prefixIconColor: Color.fromRGBO(33, 42, 62, 1),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search)),
          ),
          const Divider(color: Color.fromRGBO(33, 42, 62, 0.5)),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(height: 1),
                shrinkWrap: true,
                itemCount: data.entries.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.all(10),
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: const BorderRadius.all(Radius.circular(3)),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: Colors.grey.withOpacity(0.5),
                  //       spreadRadius: 5,
                  //       blurRadius: 7,
                  //       offset: Offset(0, 3), // changes position of shadow
                  //     ),
                  //   ],
                  // ),
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () async {
                            try {
                              await Clipboard.setData(
                                ClipboardData(
                                  text: jsonEncode({
                                    data.entries.elementAt(index).key:
                                        data.entries.elementAt(index).value,
                                  }),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to Clipboard!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to copy to clipboard.'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      JsonViewer(Map.fromEntries({
                        data.entries.elementAt(index),
                      })),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
