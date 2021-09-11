// read /etc/*release file

import 'dart:io';

import 'package:linux_system_info/linux_system_info.dart';

import 'package:about/common/utils.dart';

const unknown = "unknown";

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
}
