import 'package:about/common/io.dart';
import 'package:about/common/logos.dart';
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

  @override
  void initState() {
    super.initState();
    KitIO.startupDisk;
    setState(() {
      release = KitIO.release;
      cpuModel = KitIO.cpuModel;
      memoryTotal = KitIO.memoryTotal;
      startupDisk = KitIO.startupDisk;
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
            // TODO width => window * .333
            width: 180,
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
                  /// 操作系统
                  Text(
                    release['NAME'] ?? "",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// 版本号
                  Text.rich(
                    TextSpan(
                        text: "version",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: release['VERSION'] ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ]),
                  ),

                  /// CPU
                  Text.rich(
                    TextSpan(
                        text: "processor",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: cpuModel,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ]),
                  ),

                  /// CPU
                  Text.rich(
                    TextSpan(
                        text: "memory",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: memoryTotal,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ]),
                  ),

                  /// CPU
                  Text.rich(
                    TextSpan(
                        text: "startup disk",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: startupDisk,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ]),
                  ),

                  /// 显卡
                  Text("Graphics"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
