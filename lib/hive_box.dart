import 'package:hive_viewer/hive_item.dart';

class HiveBox {
  final String name;
  final int size;
  final List<HiveItem> items;

  HiveBox({
    required this.name,
    required this.size,
    required this.items,
  });
}
