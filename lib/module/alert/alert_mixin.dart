import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:status/module/alert/alert_controller.dart';
import 'package:status/base/extension/extension.dart';
import 'package:status/resource/app_colors.dart';

mixin Alert {
  void showDevelopingAlert(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(context.string("developing")),
      backgroundColor: AppColors.primaryLight,
    ));
  }

  void showErrorAlert(BuildContext context, String error) {
    AlertController.showError(context, error);
  }
}