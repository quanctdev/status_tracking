import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rxdart/rxdart.dart';
import 'package:status/app/application.dart';
import 'package:status/initialize_i18n/app_localizations.dart';
import 'package:status/resource/app_theme.dart';

import 'app_provider.dart';
import 'config/env.dart';
import 'router.dart';

class AppComponent extends StatefulWidget {
  final Application application;

  AppComponent(this.application);

  @override
  State createState() => AppComponentState();
}

class AppComponentState extends State<AppComponent> {
  static GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static get globalContext => AppComponentState._navigatorKey.currentState?.overlay?.context;

  final disposeBag = CompositeSubscription();
  @override
  Widget build(BuildContext context) {
    var locales =
        AppLocalizations.supportedLocales.map((s) => Locale(s)).toList();

    final materialApp = MaterialApp(
      navigatorKey: _navigatorKey,
      title: Env.value.appName,
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        const FallbackCupertinoLocalisationsDelegate(),
      ],
      supportedLocales: locales,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().light,
      onGenerateRoute: Router.generateRoute,
    );

    final appProvider = AppProvider(
      child: materialApp,
      application: widget.application,
    );

    return appProvider;
  }

  @override
  void dispose() {
    widget.application.onDestroy();
    disposeBag.dispose();
    super.dispose();
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
