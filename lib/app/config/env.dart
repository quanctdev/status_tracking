import 'package:flutter/material.dart';

import '../app_component.dart';
import '../app.dart';

enum EnvironmentType { DEVELOPMENT, PRODUCTION }

abstract class Env {
  static Env value;

  String get appName;

  bool get useHotReloadForRx;

  EnvironmentType environmentType = EnvironmentType.DEVELOPMENT;

  Env() {
    WidgetsFlutterBinding.ensureInitialized();
    value = this;
    _init();
  }

  void _init() async {
    var app = App();
    await app.onCreate();

    runApp(AppComponent(app));
  }
}
