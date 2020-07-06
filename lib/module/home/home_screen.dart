import 'package:flutter/material.dart';
import 'package:status/base/bloc_state.dart';
import 'package:status/enums/tracking_status.dart';
import 'package:status/model/tracking_info.dart';
import 'package:status/model/user.dart';
import 'package:status/module/auth/auth_header_widget.dart';
import 'package:status/module/developing/notification_widget.dart';
import 'package:status/module/home/home_bloc.dart';
import 'package:status/resource/app_colors.dart';
import 'package:status/widget/drp_rx_builder.dart';
import 'package:status/widget/rx/rx_bottom_navigation.dart';
import 'package:status/base/extension/extension.dart';
import 'package:status/widget/safe_area_color.dart';

class HomeScreen extends StatefulWidget {
  final RxBottomNavigation rxNav;

  HomeScreen({Key key, @required this.rxNav}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BlocState<HomeScreen, HomeBloc> {
  @override
  HomeBloc createBloc(BuildContext context) {
    return HomeBloc(context, widget.rxNav);
  }

  @override
  Widget onCreateView(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeAreaColor(
        color: Theme.of(context).primaryColor,
        child: Container(
            color: Colors.white,
            child: AuthHeaderWidget(
              title: context.string("menu_monitoring"),
              sliversBuilder: (User user) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      DrpRxBuilder<List<TrackingInfo>>(
                        bloc.rxTrackingInfo,
                        renderContent: _renderTrackingInfo,
                        empty: NotificationWidget(
                          image: 'images/img_alert_success.png',
                          title: 'Không có theo dõi nào',
                          description:
                              "Xin hãy ấn vào nút + ở góc phải bên dưới màn hình để tạo theo dõi",
                        ),
                      ),
                    ],
                  ),
                );
              },
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.showDialogAddUrl(),
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  Widget _renderTrackingInfo(List<TrackingInfo> data) {
    return Column(
      children: data.map((info) => _renderTrackingInfoItem(info)).toList(),
    );

    // return ListView.builder(
    //   itemCount: data.length,
    //   itemBuilder: (context, index) {
    //     return _renderTrackingInfoItem(data[index]);
    //   },
    // );
  }

  Widget _renderTrackingInfoItem(TrackingInfo item) {
    Color statusColor;
    String statusTitle;
    String lastTrackingTitle = context.string("last_tracking");
    String time = "$lastTrackingTitle ${item.lastTimeTrackingFormated}";

    switch (item.trackingStatus) {
      case TrackingStatus.UP:
        statusColor = AppColors.primaryLight;
        statusTitle = context.string("service_active");
        break;
      case TrackingStatus.DOWN:
        statusColor = AppColors.red;
        statusTitle = context.string("service_outage");
        break;
      case TrackingStatus.UNKNOWN:
        statusColor = AppColors.white;
        statusTitle = context.string("service_not_yet");
        break;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.3,
          ),
          borderRadius: BorderRadius.circular(5.0)),
      child: Material(
        color: AppColors.white,
        child: InkWell(
          onTap: () => bloc.showHistory(item),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                child: Container(
                  width: 5,
                  color: statusColor,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 12, bottom: 12, top: 12, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            statusTitle,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        Text(
                          item.code,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .apply(color: AppColors.dark),
                        ),
                        // SizedBox(width: 10),
                        // _renderBtnDeleteTrackingUrl(item)
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      item.url,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 5),
                    Text(
                      item.statusMessage,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(height: 10),
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Theme.of(context).dividerColor,
                    ),
                    SizedBox(height: 15),
                    Text(
                      time,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
