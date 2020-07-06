import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:status/module/developing/developing_widget.dart';
import 'package:status/widget/rx/rx_drp.dart';
import 'package:status/widget/rx/rx_widget.dart';

import 'button_with_border_rx_widget.dart';

typedef RenderContent<T> = Widget Function(T data);

class DrpRxBuilder<T> extends RxWidget<RxDrp<T>> {
  DrpRxBuilder(
    RxDrp<T> rx, {
    @required this.renderContent,
    this.empty,
    Key key,
  }) : super(rx, key: key);

  final RenderContent<T> renderContent;

  final Widget empty;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Drp<T>>(
        stream: rx.stream,
        builder: (context, snapshot) {
          Widget widget = Container();
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                widget = _renderLoading(snapshot.data.message ?? "");
                break;

              case Status.RETRY:
                widget = _renderLoading(snapshot.data.message ?? "");
                break;

              case Status.RECEIVE_DATA:
                T data = snapshot.data.data;
                var isListEmpty = data is List && data.length == 0;
                var isMapEmpty = data is Map && data.length == 0;
                var isEmpty = isListEmpty || isMapEmpty;
                if (empty != null && isEmpty) {
                  widget = empty;
                } else {
                  widget = renderContent(data);
                }
                break;

              case Status.ERROR:
                widget = _renderError(snapshot.data.message ?? "");
                break;
            }
          }
          return widget;
        });
  }

  Widget _renderError(String error) {
    return Column(
      children: <Widget>[
        NotificationWidget(title: 'Lỗi', description: error),
        SizedBox(height: 20),
        ButtonWithBorderRxWidget(
          null,
          onPressed: () => rx.sinkRetry(),
          title: "Thử lại",
        )
      ],
    );
  }

  Widget _renderLoading(String message) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
