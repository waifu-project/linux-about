import 'package:about/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:macwindowctl/macwindowctl.dart';

import 'widget/menu_item.dart';

void main() {
  runApp(AboutApp());

  doWhenWindowReady(() {
    const initialSize = Size(510, 360);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  configToolbar _page = configToolbar.storage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter linux about',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    WindowTitleBarBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            Macwindowctl(
                              buttonSize: 14,
                              buttonReverse: false,
                              focused: true,
                              blurSize: 24,
                              onClick: (MacwindowctlAction action) {
                                switch (action) {
                                  case MacwindowctlAction.close:
                                    return appWindow.close();
                                  case MacwindowctlAction.maximize:
                                    return appWindow.maximizeOrRestore();
                                  case MacwindowctlAction.minimize:
                                    return appWindow.minimize();
                                }
                              },
                            ),
                            Expanded(
                              child: Container(
                                child: MoveWindow(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ...Config.toolbar
                                          .map((Map<String, dynamic> item) {
                                        return MenuItem(
                                          isHover: item['action'] == _page,
                                          text: item['title'],
                                          onTap: () {
                                            setState(() {
                                              _page = item['action'];
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: _page.index,
                        children: Config.toolbar
                            .map((e) => e['page'] as Widget)
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
