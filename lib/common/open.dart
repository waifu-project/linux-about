import 'dart:io';

class Open {
  
  /// open display setting
  static bool display() {

    /// TODO impl other system
    /// NOTE:
    ///  the mehtod only support [ubuntu 20.x | xfce]
    var err = Process.runSync("xdg-open", [
      "/usr/share/applications/xfce-display-settings.desktop",
    ]).stderr;
    return err.toString().length == 0;

  }
}
