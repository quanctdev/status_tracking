import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logging/logging.dart';
import 'package:status/app/app_provider.dart';
import 'package:status/app/application.dart';
import 'package:status/app/util.dart';
import 'package:status/module/alert/alert_mixin.dart';
import 'package:status/network/repository.dart';
import 'package:status/base/extension/extension.dart';
import 'package:status/widget/rx/rx.dart';

class EventBloc<T> {
  final int key;
  T value;

  EventBloc(this.key, {this.value});
}

class RxBloc extends Rx<EventBloc> {
  CompositeSubscription disposeBag = CompositeSubscription();

  EventBloc<T> _createEvent<T>(int k, T v) => EventBloc<T>(k, value: v);

  void pushEvent<T>(int k, {T data}) {
    var event = _createEvent(k, data);
    subject.sink.add(event);
  }

  Observable<T> catchEvent<T>(int key) => subject.stream
      .where((event) => event.key == key)
      .map((event) => event.value);

  @override
  void dispose() {
    disposeBag.dispose();
    super.dispose();
  }
}

class BaseBloc extends RxBloc with Alert {
  static const int EVENT_ERROR = 0;
  static const int EVENT_TRANSACTION_COMPLETED = -1;
  static const int EVENT_DEVELOPING = -2;

  BuildContext _context;

  Logger _logger;

  BuildContext get context => _context;

  Application get app => AppProvider.get(_context);

  Repository get db => app.repository;

  Observable get transactionCompleted => catchEvent(EVENT_TRANSACTION_COMPLETED)
      .delay(Duration(microseconds: 400));

  BaseBloc(this._context) {
    _logger = Logger(toString());

    catchEvent<String>(EVENT_ERROR)
        .where((errorText) => errorText.isNotEmpty)
        .listen((error) => showErrorAlert(context, error))
        .disposed(by: disposeBag);

    catchEvent(EVENT_DEVELOPING)
        .listen((_) => showDevelopingAlert(context))
        .disposed(by: disposeBag);
  }

  void handleError(error, StackTrace stackTrace) {
    String sError = Util.getError(error);

    pushEvent<String>(EVENT_ERROR, data: sError);

    _logger.severe(sError, error, stackTrace);
  }

  void pushTransactionCompleted() {
    pushEvent(EVENT_TRANSACTION_COMPLETED);
  }

  void pushDeveloping() {
    pushEvent(EVENT_DEVELOPING);
  }
}
