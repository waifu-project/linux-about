import 'dart:convert';
import 'dart:io';

import 'dart:math';

import 'package:linux_system_info/linux_system_info.dart';

import 'package:about/common/utils.dart';

const unknown = "unknown";

enum diskType {
  HDD,
  SSD,
  Unknow,
}

typedef callMsg = void Function(int x);

class KitIO {
  /// get release info file
  /// /etc/*release
  ///   => /etc/lsb-release  || ubuntu/debian 10
  ///
  static Map<String, String> get release {
    File file = File('/etc/os-release');
    List<String> _lines = file.readAsLinesSync();
    var kv = getLinesKV(_lines);
    return kv;
  }

  static String get cpuModel {
    var cpu = CpuInfo.getProcessors()[0].model_name.trim();
    return cpu;
  }

  /// get memory total(format `GB`)
  static String get memoryTotal {
    var totalMem = MemInfo().mem_total_gb.toString();
    return '${totalMem}G';
  }

  /// 获取启动磁盘
  /// Note:
  ///   => 通过读写 /proc/mounts 文件
  ///   => 判断那一行是 '/' 即可拿到
  static get startupDisk {
    File file = File('/proc/mounts');
    List<String> lines = file.readAsLinesSync();
    var rootfs = lines.firstWhere((element) {
      var flag = element.split(" / ");
      return (flag.length >= 2);
    });
    if (rootfs.isEmpty) return unknown;
    var index = rootfs.indexOf(" ");
    if (index <= -1) return unknown;
    var result = rootfs.substring(0, index);
    return result;
  }

  /// 获取显卡
  static get graphics {
    var result = Process.runSync("lspci", []);
    var stdout = result.stdout;
    var lines = stdout.toString().split("\n");
    var line = lines.firstWhere((element) {
      // NOTE: 显卡默认显示为 `VGA`
      var check = element.contains("VGA");
      return check;
    });
    if (line.length <= 0) return unknown;
    var sp_lists = line.split(":");
    if (sp_lists.length <= 2) return unknown;
    var item = sp_lists[2];
    var tmp0 = item.split("[");
    List<String> r = [];
    tmp0.forEach((element) {
      if (element.contains("]")) {
        r.add(element);
      }
    });
    if (r.length <= 0) return unknown;
    var t = r[r.length - 1].split("]");
    if (t.length <= 0) return unknown;
    return t[0];
    // var brands = ["Intel", "NVIDIA", "AMD", "Radeon", "QXL"];
    // var brand = brands.firstWhere((element) {
    //   return line.contains(element);
    // });
    // if (brand.length <= 0) return unknown;
  }

  /// 获取尺寸大小(mm => inch)
  static String get displayInch {
    var _result = Process.runSync("xrandr", []).stdout;
    var _line = _result.toString().split("\n").firstWhere((element) {
      return element.contains(" connected");
    });
    List<String> _r = [];
    var _arr = _line.split(" ");
    _arr.forEach((element) {
      if (element.contains("mm")) {
        _r.add(element.replaceFirst("mm", ""));
      }
    });
    if (_r.length != 2) return unknown;
    var w = int.parse(_r[0]);
    var h = int.parse(_r[1]);
    // https://github.com/libredeb/comice-about/blob/ed78af0d86627405ad9ce271cd756db7d5b041b3/src/functions/GetInch.vala#L32
    if (w == 0 || h == 0) return unknown;
    int w2 = w * w;
    int h2 = h * h;
    var _r2 = (w2 + h2);
    var b = sqrt(_r2) / 25.4;
    var c = b.round();
    return '$c-inch';
  }

  /// 获取屏幕大小
  static String get displaySize {
    var _r = Process.runSync("xdpyinfo", []).stdout.toString();
    var _l = _r.split("\n").firstWhere((element) {
      return element.contains("dimensions");
    });
    var _bbr = _l.split(" ");
    var _copyR = _bbr.firstWhere((element) {
      var now = element.trim();
      if (now.length <= 1) return false;
      var s = now[0];
      var e = now[now.length - 1];

      /// NOTE:
      ///   => 最低效的算法, 通过判断索引[0, x.lenght-1]两值是否为数字
      var _r = [false, false];
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0].forEach((element) {
        var _s = element.toString();
        if (s == _s) _r[0] = true;
        if (e == _s) _r[1] = true;
      });
      return !(!_r[0] || !_r[1]);
    });
    return _copyR;
  }

  /// 获取存储设备信息
  static Map<String, String> getStorage() {
    var ref = Process.runSync("df", ["/", "-h"]);
    if (ref.stderr.toString().length >= 1) return Map();
    var io = ref.stdout.toString();
    var _io = io.split("\n");
    var _line = _io.firstWhere((element) {
      return !element.contains("Filesystem");
    });
    var fork = _line
        .replaceAll("    ", " ")
        .replaceAll("   ", " ")
        .replaceAll("  ", " ")
        .split(" ");
    var _m = {
      "name": fork[0],
      "size": fork[1],
      "used": fork[2],
      "avail": fork[3],
      "percentage": fork[4],
    };
    return _m;
  }

  /// 获取磁盘设备类型
  static diskType getDiskType(String pname, {callMsg? callback}) {
    var pp = pname.split("/");
    if (pp.length <= 2) return diskType.Unknow;
    var rname = pp[2];
    var blk = Process.runSync("lsblk", ["-b", "-J"]);
    var res = jsonDecode(blk.stdout.toString());
    if (res == null) return diskType.Unknow;
    List<dynamic> devices = res['blockdevices'];
    var _now = devices.firstWhere((element) {
      dynamic children = element['children'];
      if (children == null) return false;
      return children.any((element) {
        var check = element['name'] == rname;
        return check;
      });
    });
    if (callback != null) callback(_now['size']);
    var rootfs = _now['name'];
    var statFile = "/sys/block/$rootfs/queue/rotational";
    var out = Process.runSync("cat", [statFile]).stdout.toString().trim();
    var outCopy = int.tryParse(out);
    if (outCopy == null) return diskType.Unknow;
    switch (outCopy) {
      case 0:
        return diskType.SSD;
      case 1:
        return diskType.HDD;
      default:
        return diskType.Unknow;
    }
  }
}
