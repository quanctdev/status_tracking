import 'dart:async';
import 'package:flutter/material.dart';

import 'en.dart';

class AppLocalizations {
  static List<String> supportedLocales = ['en'];

  AppLocalizations(Locale locale) {
    this.locale = locale;
    _localizedValues = null;
  }

  Locale locale;
  static Map<dynamic, dynamic> _localizedValues;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String text(String key) {
    return _localizedValues[key] ?? '** $key not found';
  }

  static Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations translations = new AppLocalizations(locale);
    _localizedValues = en;
    return translations;
  }

  get currentLanguage => locale.languageCode;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
