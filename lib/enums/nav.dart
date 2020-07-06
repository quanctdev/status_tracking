import 'package:flutter/material.dart';
import 'package:status/base/extension/extension.dart';

enum Nav { HOME, SETTING, REPORTING }

extension NavigationItemExt on Nav {
  String getTitle(BuildContext context) {
    String result = "";
    switch (this) {
      case Nav.HOME:
        result = context.string("menu_monitoring");
        break;
      case Nav.SETTING:
        result = context.string("menu_setting");
        break;
      case Nav.REPORTING:
         result = context.string("menu_reporting");
        break;
    }

    return result;
  }

  IconData get assetRes {
    IconData result;
    switch (this) {
      case Nav.HOME:
        result = Icons.personal_video;
        break;
      case Nav.SETTING:
        result = Icons.settings;
        break;
      case Nav.REPORTING:
         result = Icons.insert_chart;
        break;
    }

    return result;
  }
}
