import 'package:about/common/io.dart';
import 'package:about/widget/pbar.dart';
import 'package:flutter/material.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  _StoragePageState createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  Map<String, String> _map = Map();

  int _rootfsTotal = 0;

  diskType _type = diskType.Unknow;

  String get diskTypeString {
    var _cc = _type.toString();
    return _cc.split(".")[1].toUpperCase() + " Disk";
  }

  String get rootfsTotal {
    if (_rootfsTotal <= 0) {
      return unknown;
    }
    var r = (_rootfsTotal / (1024 * 1024 * 1024));
    var _ = r.toStringAsFixed(2);
    return '${_}GB';
  }

  bool get mapIsEmptry {
    return _map.isEmpty;
  }

  String get diskUsedAndTotal {
    return "${_map['avail'] ?? ''} available of ${_map['size'] ?? ''}";
  }

  double get progressBarValue {
    var n = int.tryParse((_map['percentage'] as String).split("%")[0]);
    if (n == null) return 0;
    return n / 100;
  }

  @override
  void initState() {
    setState(() {
      _map = KitIO.getStorage();
      var pname = _map['name'] ?? "";
      if (pname != "") {
        var type = KitIO.getDiskType(pname, callback: (msg) {
          _rootfsTotal = msg;
        });
        _type = type;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (mapIsEmptry) {
      return Container(
        child: Center(
          child: Text("Get failed or loading"),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 9,
      ),
      child: Row(
        children: [
          Column(
            children: [
              Image.asset("assets/images/hdd.png"),
              SizedBox(
                height: 12,
              ),
              Text(
                rootfsTotal,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(diskTypeString,
                  style: TextStyle(
                    fontSize: 12,
                  )),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _map['name'] ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(0, 0, 0, .1),
                            ),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 3,
                          ),
                          child: Text(
                            "Manage",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(diskUsedAndTotal),
                  // Text(_map['percentage'] ?? ""),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: CupertinoProgressBar(
                      value: progressBarValue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
