import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'rx/rx_smart_refresher.dart';
import 'rx/rx_widget.dart';

class SmartRefresherRxWidget extends RxWidget<RxSmartRefresher> {
  SmartRefresherRxWidget(
    RxSmartRefresher rx, {
    @required this.child,
    @required this.enablePullDown,
    @required this.enablePullUp,
    Key key,
  }) : super(rx, key: key);

  final Widget child;
  final bool enablePullDown;
  final bool enablePullUp;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: rx.controller,
      onRefresh: rx.sinkPullToRefresh,
      onLoading: rx.sinkLoadMore,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      child: child,
    );
  }
}
