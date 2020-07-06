import 'package:flutter/material.dart';
import 'package:status/app/app_provider.dart';
import 'package:status/model/user.dart';
import 'package:status/module/setting/setting_sliver_delegate.dart';
import 'package:status/resource/app_colors.dart';

typedef SliverListBuilder = SliverList Function(User user);

class AuthHeaderWidget extends StatelessWidget {
  final SliverListBuilder sliversBuilder;
  final String title;

  const AuthHeaderWidget({
    Key key,
    @required this.sliversBuilder,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: AppProvider.authBloc(context).userStream,
        builder: (context, snapshot) {
          User user = snapshot?.data;
          bool isSignIn = user != null;

          return CustomScrollView(
            slivers: <Widget>[
              renderHeader(context, isSignIn, title: title),
              sliversBuilder(user),
            ],
          );
        });
  }

  Widget renderHeader(BuildContext context, bool isSignIn,
      {String title = ""}) {
    Widget header = SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: SettingSliverDelegate(
        title: title,
        expandedHeight: MediaQuery.of(context).size.width * (250 / 850),
      ),
    );

    if (isSignIn) {
      header = SliverAppBar(
        pinned: true,
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline4
              .apply(color: AppColors.white),
        ),
      );
    }

    return header;
  }
}
