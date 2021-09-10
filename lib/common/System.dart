enum SystemType {
  // windows not support flutter desktop(next support the version)
  windows,

  // i runing system is ubuntu 18.x.x
  linux,

  // macos native support
  macos
}

class SystemInfo {
  String cpuInfo;

  String releaseInfo;

  SystemInfo(
    this.cpuInfo,
    this.releaseInfo
  );

  // get system type
  SystemType get systemType {
    return SystemType.linux;
  }
}
