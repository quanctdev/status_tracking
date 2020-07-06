import 'package:rxdart/rxdart.dart';
import 'package:status/app/util.dart';
import 'package:status/widget/rx/rx.dart';

class Drp<T> {
  Status status;
  T data;
  String message;

  Drp.loading({this.message}) : status = Status.LOADING;
  Drp.retry({this.message}) : status = Status.RETRY;
  Drp.data(this.data) : status = Status.RECEIVE_DATA;
  Drp.error(this.message) : status = Status.ERROR;
}

enum Status { LOADING, RECEIVE_DATA, ERROR, RETRY }

class RxDrp<T> extends Rx<Drp<T>> {
  RxDrp({initValue})
      : super(initValue: initValue != null ? initValue : Drp<T>.loading());

  Observable<void> get retry =>
      stream.where((event) => event.status == Status.RETRY);

  Observable<void> get loadingDone =>
      stream.where((event) => event.status == Status.RECEIVE_DATA);

  Observable<T> get dataStream => stream
      .where((event) => event.status == Status.RECEIVE_DATA)
      .map((event) => event.data);

  void sinkLoading() {
    Drp<T> drp = Drp.loading();

    sink.add(drp);
  }

  void sinkError(error, StackTrace stackTrace) {
    String sError = Util.getError(error);
    Drp<T> drp = Drp.error(sError);

    sink.add(drp);
  }

  void sinkData(T data) {
    Drp<T> drp = Drp.data(data);

    sink.add(drp);
  }

  void sinkRetry() {
    Drp<T> drp = Drp.retry();

    sink.add(drp);
  }
}
