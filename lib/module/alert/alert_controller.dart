import 'package:flutter/material.dart';
import 'package:status/module/alert/alert_action.dart';
import 'package:status/base/extension/extension.dart';

import 'alert_widget.dart';

class AlertController {
  static Future<int> _show(
    BuildContext context, {
    int action = AlertAction.NONE,
    String title = "",
    String description = "",
    String image,
  }) {
    Future<int> alert = showGeneralDialog(
        useRootNavigator: true,
        barrierColor: Color(0x21000000),
        transitionBuilder: (ct, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertWidget(
                action: action,
                title: title,
                description: description,
                image: image,
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 150),
        barrierDismissible: true,
        context: context,
        barrierLabel: "",
        pageBuilder: (ct, animation1, animation2) {
          return Container();
        });

    return alert;
  }

  static Future<int> showOption(
    BuildContext context, {
    String title = "",
    String description = "",
  }) {
    return _show(
      context,
      action: AlertAction.CANCEL | AlertAction.DONE,
      title: title,
      description: description,
      image: "images/img_alert_success.png",
    );
  }

  static Future<int> showError(BuildContext context, String message) {
    return _show(
      context,
      action: AlertAction.CANCEL,
      title: context.string("error_title"),
      description: message,
      image: "images/img_alert_success.png",
    );
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}
