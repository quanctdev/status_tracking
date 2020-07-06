import 'package:flutter/material.dart';
import 'package:status/base/bloc_state.dart';
import 'package:status/model/user.dart';
import 'package:status/module/auth/auth_header_widget.dart';
import 'package:status/module/setting/setting_bloc.dart';
import 'package:status/resource/app_colors.dart';
import 'package:status/widget/rx/rx_bottom_navigation.dart';
import 'package:status/widget/safe_area_color.dart';
import 'package:status/base/extension/extension.dart';

class SettingScreen extends StatefulWidget {
  final RxBottomNavigation rxNav;

  SettingScreen({Key key, @required this.rxNav}) : super(key: key);
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends BlocState<SettingScreen, SettingBloc> {
  @override
  SettingBloc createBloc(BuildContext context) {
    return SettingBloc(context, widget.rxNav);
  }

  @override
  Widget onCreateView(BuildContext context) {
    return Scaffold(
      body: SafeAreaColor(
        color: Theme.of(context).primaryColor,
        child: Container(
            color: Colors.white,
            child: AuthHeaderWidget(
              title: context.string("menu_setting"),
              sliversBuilder: (User user) {
                var isSignIn = user != null;
                var developing = () => bloc.pushDeveloping();
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(height: 10),
                      renderSettingHeader("Alarm"),
                      renderSettingOption("Slack", onPressed: developing),
                      renderSettingOption("Email", onPressed: developing),
                      renderSettingOption("Notification", onPressed: developing),
                      renderDivider(),
                      renderSettingHeader("Support"),
                      renderSettingOption("About App", onPressed: developing),
                      renderSettingOption("Feedback", onPressed: developing),
                      renderSettingOption("Privacy Policy", onPressed: developing),
                      renderDivider().visible(isSignIn),
                      renderSettingOption(
                        "Logout",
                        titleColor: AppColors.red,
                        onPressed: bloc.signOut,
                      ).visible(isSignIn)
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget renderSettingHeader(String title) {
    Widget btn = Padding(
      padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
      child: Text(title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 16)),
    );

    return btn;
  }

  Widget renderSettingOption(String title,
      {Color titleColor, Function onPressed}) {
    var style = Theme.of(context).textTheme.headline6;
    if (titleColor != null) {
      style = style.apply(color: titleColor);
    }

    return Material(
      color: AppColors.white,
      child: InkWell(
        onTap: () => onPressed(),
        child: Padding(
          padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ),
    );
  }

  Widget renderDivider() {
    return Padding(
        padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
        child: Divider(
          height: 1,
          thickness: 0.5,
          color: Theme.of(context).dividerColor,
        ));
  }

//   Widget renderSignOutButton(bool isSignIn) {
//     Widget btn = Padding(
//       padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
//       child: ButtonWithBorder(
//         bloc.btnSignOut,
//         color: Theme.of(context).primaryColor,
//         title: "Sign out",
//         width: double.infinity,
//       ),
//     );

//     if (!isSignIn) {
//       btn = Container();
//     }

//     return btn;
//   }

//   Widget renderNotificationSetting() {
//     return Card(
//         margin: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(
//             side: BorderSide(
//               color: Theme.of(context).dividerColor,
//               width: 0.3,
//             ),
//             borderRadius: BorderRadius.circular(5.0)),
//         child: Container(
//             padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
//             child: Row(
//               children: <Widget>[
//                 Image(
//                   width: 38,
//                   height: 38,
//                   image: AssetImage('images/ic_notification.png'),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                     child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text("Notification",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.title),
//                     SizedBox(height: 5),
//                     Text("Notification",
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.subhead),
//                   ],
//                 )),
//                 CheckBox(null),
//               ],
//             )));
//   }

//   Widget renderAppInfo() {
//     return Container(
//         margin: EdgeInsets.only(top: 20, bottom: 20),
//         child: Center(
//             child: Text("UrlTracking App - 2019 create by (•‿•)",
//                 style: Theme.of(context).textTheme.subtitle)));
//   }

//   Widget renderAboutApp(String title, String description) {
//     return Card(
//         margin: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(
//             side: BorderSide(
//               color: Theme.of(context).dividerColor,
//               width: 0.3,
//             ),
//             borderRadius: BorderRadius.circular(5.0)),
//         child: Container(
//           padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Text(title,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.title),
//               SizedBox(height: 15),
//               Text(description, style: Theme.of(context).textTheme.subtitle),
//             ],
//           ),
//         ));
//   }

//   Widget renderGeneralSettings() {
//     return Card(
//         margin: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(
//             side: BorderSide(
//               color: Theme.of(context).dividerColor,
//               width: 0.3,
//             ),
//             borderRadius: BorderRadius.circular(5.0)),
//         child: Container(
//           padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
//           child: Row(
//             children: <Widget>[
//               Image(
//                 width: 38,
//                 height: 38,
//                 image: AssetImage('images/ic_settings.png'),
//               ),
//               SizedBox(width: 10),
//               Expanded(
//                   child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text("General Settings",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: Theme.of(context).textTheme.title),
//                   SizedBox(height: 5),
//                   Text("General settings",
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: Theme.of(context).textTheme.subhead),
//                 ],
//               )),
//             ],
//           ),
//         ));
//   }

//   Widget renderEmailSetting() {
//     return Card(
//         margin: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(
//             side: BorderSide(
//               color: Theme.of(context).dividerColor,
//               width: 0.3,
//             ),
//             borderRadius: BorderRadius.circular(5.0)),
//         child: Container(
//             padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Image(
//                       width: 38,
//                       height: 38,
//                       image: AssetImage('images/ic_mail.png'),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                         child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text("Email",
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context).textTheme.title),
//                         SizedBox(height: 5),
//                         Text("Email",
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context).textTheme.subhead),
//                       ],
//                     )),
//                     CheckBox(null),
//                   ],
//                 ),
//                 SizedBox(height: 15),
//                 Text("#Type: GMail",
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context).textTheme.subtitle),
//                 SizedBox(height: 5),
//                 Text("#User: youremail@gmail.com",
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context).textTheme.subtitle),
//                 SizedBox(height: 5),
//                 Text("#Subject: Sending Email using UrlTracking",
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context).textTheme.subtitle),
//               ],
//             )));
//   }

//   Widget renderSlackSetting() {
//     return Card(
//         margin: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(
//             side: BorderSide(
//               color: Theme.of(context).dividerColor,
//               width: 0.3,
//             ),
//             borderRadius: BorderRadius.circular(5.0)),
//         child: Container(
//             padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Image(
//                       width: 38,
//                       height: 38,
//                       image: AssetImage('images/ic_slack.png'),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                         child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text("Slack",
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context).textTheme.title),
//                         SizedBox(height: 5),
//                         Text("Slack",
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context).textTheme.subhead),
//                       ],
//                     )),
//                     CheckBox(null),
//                   ],
//                 ),
//                 SizedBox(height: 15),
//                 Text("#Token: SLACK_AUTH_TOKEN",
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context).textTheme.subtitle),
//                 SizedBox(height: 5),
//                 Text("#Channel: Bot Tutorials",
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context).textTheme.subtitle),
//               ],
//             )));
//   }
}
