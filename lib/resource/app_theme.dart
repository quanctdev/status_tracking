import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  ThemeData light = ThemeData(
    primaryColor: AppColors.primaryLight,
    accentColor: AppColors.primaryLight,
    buttonColor: AppColors.primaryLight,
    dividerColor: AppColors.background,
    textTheme: TextTheme(
        headline6: _title,
        subtitle2: _subtitle,
        headline4: _display1,
        headline3: _display2,
        subtitle1: _subhead),
  );

  static const TextStyle _display1 = const TextStyle(
    color: AppColors.white,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _display2 = const TextStyle(
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle _title = const TextStyle(
    color: AppColors.dark,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _subtitle = const TextStyle(
    color: AppColors.dark,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle _subhead = const TextStyle(
    color: AppColors.background,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
