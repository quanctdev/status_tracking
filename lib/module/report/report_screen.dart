import 'package:flutter/material.dart';
import 'package:status/base/bloc_state.dart';
import 'package:status/model/user.dart';
import 'package:status/module/auth/auth_header_widget.dart';
import 'package:status/module/developing/notification_widget.dart';
import 'package:status/module/report/report_bloc.dart';
import 'package:status/widget/safe_area_color.dart';
import 'package:status/base/extension/extension.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({Key key}) : super(key: key);
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends BlocState<ReportScreen, ReportBloc> {
  @override
  ReportBloc createBloc(BuildContext context) {
    return ReportBloc(context);
  }

  @override
  Widget onCreateView(BuildContext context) {
    return Scaffold(
      body: SafeAreaColor(
        color: Theme.of(context).primaryColor,
        child: Container(
            color: Colors.white,
            child: AuthHeaderWidget(
              title: context.string("menu_reporting"),
              sliversBuilder: (User user) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      NotificationWidget(
                        title: context.string("developing_title"),
                        description: context.string("developing"),
                      ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
