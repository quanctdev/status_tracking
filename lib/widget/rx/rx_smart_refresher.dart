import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

import 'rx.dart';

class RxSmartRefresher extends Rx<int> {
  int _offset;

  RefreshController _refreshController;

  RxSmartRefresher({page}) : super(initValue: page) {
    _refreshController = RefreshController(initialRefresh: false);

    _offset = page;
  }

  RefreshController get controller => _refreshController;

  Observable<int> get pullToRefresh => stream.where((offset) => offset == 1);

  Observable<int> get loadMore => stream.where((offset) => offset > 1);

  sinkPullToRefresh() {
    _offset = 1;
    sink.add(_offset);
  }

  sinkLoadMore() {
    _offset += 1;
    sink.add(_offset);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
