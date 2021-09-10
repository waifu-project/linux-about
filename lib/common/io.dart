// read /etc/*release file

import 'dart:io';

import 'package:linux_system_info/linux_system_info.dart';

import 'package:about/common/utils.dart';

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
    if (rootfs.isEmpty) return "";
    var index = rootfs.indexOf(" ");
    if (index <= -1) return "";
    var result = rootfs.substring(0, index);
    return result;
  }
}
