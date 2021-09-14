import 'package:about/pages/display.dart';
import 'package:about/pages/memory.dart';
import 'package:about/pages/overflow.dart';
import 'package:about/pages/storage.dart';

enum configToolbar {
  overflow,
  display,
  storage,
  memory,
}

class Config {

  // TODO i18n
  static List<Map<String, dynamic>> toolbar = [
    {
      "title": "overflow",
      "action": configToolbar.overflow,
      "page": new OverflowPage(),
    },
    {
      "title": "display",
      "action": configToolbar.display,
      "page": new DisplayPage(),
    },
    {
      "title": "storage",
      "action": configToolbar.storage,
      "page": new StoragePage(),
    },
    {
      "title": "memory",
      "action": configToolbar.memory,
      "page": new MemoryPage(),
    },
  ];
}
