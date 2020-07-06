import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:status/widget/smart_refresher_rx_widget.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:status/base/bloc_state.dart';
import 'package:status/base/bundle_stateful_widget.dart';
import 'package:status/model/tracking_history.dart';
import 'package:status/module/developing/notification_widget.dart';
import 'package:status/resource/app_colors.dart';
import 'package:status/widget/drp_rx_builder.dart';
import 'package:status/widget/title_appbar.dart';
import 'package:status/base/extension/extension.dart';

import 'history_bloc.dart';

class HistoryScreen extends BundleStatefulWidget {
  HistoryScreen({Key key, Bundle bundle}) : super(key: key, bundle: bundle);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends BlocState<HistoryScreen, HistoryBloc> {
  @override
  HistoryBloc createBloc(BuildContext context) {
    return HistoryBloc(context, widget.bundle);
  }

  @override
  Widget onCreateView(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        title: context.string("history"),
        color: AppColors.primaryLight,
        haveButtonBack: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        constraints: new BoxConstraints.expand(),
        color: Colors.white,
        child: DrpRxBuilder<Map<String, List<TrackingHistory>>>(
          bloc.rxHis,
          renderContent: _renderHistory,
          empty: NotificationWidget(
            image: 'images/img_good.png',
            title: context.string("good_system_title"),
            description: context.string("good_system_description"),
          ),
        ),
      ),
    );
  }

  Widget _renderHistory(Map<String, List<TrackingHistory>> data) {
    var listKey = data.keys.toList();

    return SmartRefresherRxWidget(
      bloc.rxRefresher,
      enablePullDown: true,
      enablePullUp: bloc.enableLoadMore,
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            String currentKey = listKey[index];
            List<TrackingHistory> currentData = data[currentKey];

            return StickyHeader(
              header: Container(
                  height: 30,
                  color: AppColors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 60,
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          currentKey,
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .apply(color: AppColors.primaryLight),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1.0,
                        color: AppColors.background,
                      ),
                    ],
                  )),
              content: Column(
                children:
                    currentData.map((his) => _renderHistoryItem(his)).toList(),
              ),
            );
          }),
    );
  }

  Widget _renderHistoryItem(TrackingHistory history) {
    var color = history.isError ? AppColors.background : AppColors.primaryLight;

    return Column(
      children: <Widget>[
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 60,
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Text(
                  history.at,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 12),
                ),
              ),
              Wrap(
                direction: Axis.vertical,
                children: <Widget>[
                  Container(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        VerticalDivider(
                          thickness: 1.0,
                          color: AppColors.background,
                        ),
                        Positioned(
                          top: 10,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 10, top: 5),
                      child: Text(
                        history.statusCode,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 10, top: 5),
                      child: Text(
                        history.statusMessage,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    SizedBox(height: 15)
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
