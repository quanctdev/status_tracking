import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:status/base/base_bloc.dart';
import 'package:status/base/bundle_stateful_widget.dart';
import 'package:status/model/tracking_history.dart';
import 'package:status/model/tracking_info.dart';
import 'package:status/widget/rx/rx_drp.dart';
import 'package:status/base/extension/extension.dart';
import "package:collection/collection.dart";
import 'package:status/widget/rx/rx_smart_refresher.dart';

class HistoryBloc extends BaseBloc {
  RxDrp<Map<String, List<TrackingHistory>>> rxHis;

  RxSmartRefresher rxRefresher;

  DocumentSnapshot lastDoc;

  //Convert this value to stream if it is updated before updating the list data
  bool enableLoadMore = true;

  HistoryBloc(BuildContext context, Bundle bundle) : super(context) {
    var trackingInfo = bundle.getData<TrackingInfo>("TrackingInfo");

    rxHis = RxDrp();
    rxRefresher = RxSmartRefresher(page: 1);

    rxHis.loadingDone.listen((_) => rxRefresher.controller.refreshCompleted());
    rxHis.loadingDone.listen((_) => rxRefresher.controller.loadComplete());

    var retry = rxHis.retry;
    var refresh = rxRefresher.pullToRefresh.doOnData((_) => lastDoc = null);
    var loadMore = rxRefresher.loadMore;

    Observable.merge([retry, refresh, loadMore])
        .flatMap(
          (_) => db
              .getTrackingHistoryByInfo(trackingInfo, lastDoc)
              .doOnData((his) => lastDoc = his.last.snapshot)
              .doOnData((his) => enableLoadMore = his.length >= 20),
        )
        .withLatestFrom2(
          rxHis.dataStream.startWith(null),
          rxRefresher.stream,
          processingData,
        )
        .map((his) => groupBy<TrackingHistory, String>(his, (obj) => obj.date))
        .map((data) => Drp.data(data))
        .listen(rxHis.sink.add, onError: rxHis.sinkError)
        .disposed(by: disposeBag);
  }

  List<TrackingHistory> processingData(
    List<TrackingHistory> nData,
    Map<String, List<TrackingHistory>> oData,
    int page,
  ) {
    var data = nData;
    if (page != 1) {
      data = oData.values.reduce((value, element) => value + element) + data;
    }
    return data;
  }

  @override
  void dispose() {
    rxHis.dispose();
    rxRefresher.dispose();
    super.dispose();
  }
}
