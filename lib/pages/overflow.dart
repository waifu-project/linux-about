import 'package:about/common/io.dart';
import 'package:about/common/logos.dart';
import 'package:about/widget/overflow_item.dart';
import 'package:flutter/material.dart';

class OverflowPage extends StatefulWidget {
  const OverflowPage({Key? key}) : super(key: key);

  @override
  _OverflowPageState createState() => _OverflowPageState();
}

class _OverflowPageState extends State<OverflowPage> {
  Map<String, String> release = new Map();

  String cpuModel = "";

  String memoryTotal = "";

  String startupDisk = "";

  String graphics = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      release = KitIO.release;
      cpuModel = KitIO.cpuModel;
      memoryTotal = KitIO.memoryTotal;
      startupDisk = KitIO.startupDisk;
      graphics = KitIO.graphics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, .02),
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .333,
            height: double.infinity,
            child: Center(
              child: Icon(
                Logos.ubuntu,
                size: 120,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    release['NAME'] ?? "",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  OverflowItem(k: "version",v: release['VERSION'] ?? "",kBold: false,),
                  SizedBox(height: 12,),
                  OverflowItem(k: "processor", v: cpuModel),
                  OverflowItem(k: "memory", v: memoryTotal),
                  OverflowItem(k: "startup disk", v: startupDisk),
                  OverflowItem(k: "graphics", v: graphics)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
