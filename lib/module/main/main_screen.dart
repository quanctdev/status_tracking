import 'package:flutter/material.dart';
import 'package:status/base/bloc_state.dart';
import 'package:status/enums/nav.dart';
import 'package:status/module/home/home_screen.dart';
import 'package:status/module/report/report_screen.dart';
import 'package:status/module/setting/setting_screen.dart';
import 'package:status/widget/bottom_navigation_rx_widget.dart';

import 'main_bloc.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends BlocState<MainScreen, MainBloc> {
  @override
  MainBloc createBloc(BuildContext context) {
    return MainBloc(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget onCreateView(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bloc.onBack();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          constraints: new BoxConstraints.expand(),
          color: Colors.white,
          child: StreamBuilder<int>(
              stream: bloc.rxNav.curIndexSelected,
              initialData: bloc.rxNav.initIndex,
              builder: (context, snapshot) {
                return IndexedStack(
                  index: snapshot.data,
                  children: bloc.rxNav.items.map<Widget>((Nav tabItem) {
                    Widget screen = Container(color: Colors.red);
                    GlobalKey<NavigatorState> key;
                    switch (tabItem) {
                      case Nav.HOME:
                        screen = HomeScreen(rxNav: bloc.rxNav);
                        key = bloc.homeNavigator;
                        break;
                      case Nav.SETTING:
                        screen = SettingScreen(rxNav: bloc.rxNav);
                        key = bloc.settingNavigator;
                        break;
                      case Nav.REPORTING:
                        screen = ReportScreen();
                        key = bloc.reportingNavigator;
                        break;
                    }

                    return Navigator(
                      key: key,
                      onGenerateRoute: (RouteSettings settings) {
                        return MaterialPageRoute(
                          settings: settings,
                          builder: (BuildContext context) => screen,
                        );
                      },
                    );
                  }).toList(),
                );
              }),
        ),
        bottomNavigationBar: BottomNavigationRxWidget(bloc.rxNav),
      ),
    );
  }
}
