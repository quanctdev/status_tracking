import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:status/base/bundle_stateful_widget.dart';
import 'package:status/model/tracking_info.dart';
import 'package:status/module/add_tracking/add_tracking_screen.dart';
import 'package:status/module/history/history_screen.dart';
import 'package:status/module/main/main_screen.dart';
import 'package:status/module/splash/splash_screen.dart';

class Router {
  static const SPLASH = '/';
  static const MAIN = '/main';
  static const ADD_TRACKING = '/add_tracking';
  static const TRACKING_HISTORY = '/tracking_history';

  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SPLASH:
        var screen = SplashScreen();
        return CupertinoPageRoute(builder: (context) => screen);
      case MAIN:
        var screen = MainScreen();
        return CupertinoPageRoute(builder: (context) => screen);
      case TRACKING_HISTORY:
        var data = settings.arguments as TrackingInfo;
        var screen = HistoryScreen(
          bundle: MapBundle(bundle: {"TrackingInfo": data}),
        );
        return CupertinoPageRoute<String>(builder: (context) => screen);
      case ADD_TRACKING:
        var screen = AddTrackingScreen();
        return CupertinoPageRoute<String>(builder: (context) => screen);
      default:
        return CupertinoPageRoute(builder: (context) => MainScreen());
    }
  }
}
