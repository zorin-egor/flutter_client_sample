import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterclientsample/ui/base/constants.dart';
import 'package:flutterclientsample/ui/users/users_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    debugPrint("Window size: ${window.physicalSize}");

    if (isAndroid(context)) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.black38
      ));
    }

    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      initialRoute: UsersScreen.ROUTE,
      routes: {
        UsersScreen.ROUTE: (BuildContext context) => UsersScreen()
      }
    );
  }

}