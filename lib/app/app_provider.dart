import 'package:flutter/material.dart';
import 'package:status/module/auth/auth_bloc.dart';

import 'application.dart';

class AppProvider extends InheritedWidget {
  final Application application;

  AppProvider({
    Key key,
    @required Widget child,
    @required this.application,
  }) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static AppProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppProvider>();
  }

  static Application get(BuildContext context) {
    return AppProvider.of(context).application;
  }

  static AuthBloc authBloc(BuildContext context) {
    return AppProvider.get(context).authBloc;
  }
}
