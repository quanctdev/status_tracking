import 'package:flutter/widgets.dart';
import 'package:status/base/base_bloc.dart';
import 'package:status/enums/nav.dart';
import 'package:status/widget/rx/rx_bottom_navigation.dart';
import 'package:status/base/extension/extension.dart';

class MainBloc extends BaseBloc {
  static const int EVENT_BACK = 1;

  final homeNavigator = GlobalKey<NavigatorState>();
  final analyticsNavigator = GlobalKey<NavigatorState>();
  final notifiNavigator = GlobalKey<NavigatorState>();
  final settingNavigator = GlobalKey<NavigatorState>();
  final reportingNavigator = GlobalKey<NavigatorState>();

  RxBottomNavigation rxNav;

  MainBloc(BuildContext context) : super(context) {
    var tab = [Nav.HOME,  Nav.REPORTING, Nav.SETTING];

    rxNav = RxBottomNavigation(tab);

    catchEvent(EVENT_BACK)
        .withLatestFrom(rxNav.curItemSelected, _handlerBack)
        .listen((_) {})
        .disposed(by: disposeBag);
  }

  void _handlerBack(_, Nav current) {
    GlobalKey<NavigatorState> navigator;
    switch (current) {
      case Nav.HOME:
        navigator = homeNavigator;
        break;
      case Nav.SETTING:
        navigator = settingNavigator;
        break;
      case Nav.REPORTING:
        navigator = reportingNavigator;
        break;
    }

    if (navigator.currentState.canPop()) {
      navigator.currentState.pop(context);
    } else {
      if (current == Nav.HOME) {
        //BackStackPlugin.moveTaskToBack();
      } else {
        rxNav.sink.add(Nav.HOME);
      }
    }
  }

  void onBack() => pushEvent(EVENT_BACK);

  @override
  void dispose() {
    rxNav.dispose();
    super.dispose();
  }
}
