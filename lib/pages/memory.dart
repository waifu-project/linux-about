import 'package:about/common/io.dart';
import 'package:flutter/material.dart';

// TODO impl
class MemoryPage extends StatefulWidget {
  const MemoryPage({Key? key}) : super(key: key);

  @override
  _MemoryPageState createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  @override
  void initState() {
    KitIO.getMemoryInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("render memory page"),
    );
  }
}
