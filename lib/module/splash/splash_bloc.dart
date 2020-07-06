import 'package:flutter/widgets.dart';
import 'package:status/app/app_provider.dart';
import 'package:status/app/router.dart';
import 'package:status/base/base_bloc.dart';
import 'package:status/module/auth/auth_bloc.dart';
import 'package:status/base/extension/extension.dart';

class SplashBloc extends BaseBloc {
  SplashBloc(BuildContext context) : super(context) {
    AuthBloc authBloc = AppProvider.authBloc(context);

    authBloc.userStream
        .listen((_) => Navigator.of(context, rootNavigator: true).pushReplacementNamed(Router.MAIN))
        .disposed(by: disposeBag);
  }
}
