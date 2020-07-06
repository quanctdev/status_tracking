import 'package:flutter/material.dart';
import 'package:status/app/app_provider.dart';
import 'package:status/base/nav_bloc_state.dart';
import 'package:status/enums/nav.dart';
import 'package:status/module/auth/auth_bloc.dart';
import 'package:status/widget/rx/rx_bottom_navigation.dart';

class SettingBloc extends NavBlocState {
  static const int EVENT_SIGN_OUT = 1;

  SettingBloc(BuildContext context, RxBottomNavigation rxNav)
      : super(context, rxNav: rxNav, navType: Nav.SETTING) {
    catchEvent(EVENT_SIGN_OUT).listen((_) {
      AuthBloc authBloc = AppProvider.authBloc(context);
      authBloc.signOut();
    });
  }

  void signOut() {
    pushEvent(EVENT_SIGN_OUT);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
