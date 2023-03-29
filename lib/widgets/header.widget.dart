import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Row(
        children: [
          IconButton(onPressed: () => null, icon: const Icon(Icons.folder)),
          Text("<path/de/la/db>"),
        ],
      ),
      Text("<Logo> HiveView <version>")
    ]);
  }
}
