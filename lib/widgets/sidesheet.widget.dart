import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_viewer/ui/app_view_model.dart';
import 'package:hive_viewer/ui/hive_controller.dart';
import 'package:provider/provider.dart';

class SideSheetWidget extends StatelessWidget {
  const SideSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> boxesName = context.select(
      (AppViewModel value) => value.boxesName,
    );

    return Container(
      color: Color.fromRGBO(33, 42, 62, 1),
      width: 300,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  color: Color.fromRGBO(241, 246, 249, 1),
                  onPressed: () async {
                    String? selectedDirectory =
                        await FilePicker.platform.getDirectoryPath();
                    if (selectedDirectory != null && context.mounted) {
                      context.read<HiveController>().onInitDatabase(selectedDirectory);
                    }
                  },
                  icon: const Icon(
                    Icons.folder,
                  )),
              Tooltip(
                message: context.read<AppViewModel>().databasePath,
                child: Text(
                  context.read<AppViewModel>().databasePathForDisplay,
                  style:
                      const TextStyle(color: Color.fromRGBO(241, 246, 249, 1)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                color: Color.fromRGBO(241, 246, 249, 1),
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    context.read<HiveController>().onRefreshDatabase(),
              ),
              Row(
                children: [
                  Text(
                    boxesName.length.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(241, 246, 249, 1)),
                  ),
                  Text(" box${boxesName.isNotEmpty ? "es" : ""}",
                      style: const TextStyle(
                          color: Color.fromRGBO(241, 246, 249, 1)))
                ],
              ),
            ],
          ),
          TextField(
            onChanged: (text) {
              context.read<HiveController>().onBoxLoad(filter: text);
            },
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(241, 246, 249, 1)),
            decoration: const InputDecoration(
                prefixIconColor: Color.fromRGBO(241, 246, 249, 1),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search)),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const Divider(color: Color.fromRGBO(57, 72, 103, 0.8)),
                shrinkWrap: true,
                itemCount: boxesName.length,
                itemBuilder: (context, index) {
                  final item = boxesName[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(item,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(241, 246, 249, 1))),
                      ),
                      onTap: () => context
                          .read<HiveController>()
                          .onBoxDataLoad(boxId: item),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
