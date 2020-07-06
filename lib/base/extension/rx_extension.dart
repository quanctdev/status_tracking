import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:status/app/app_component.dart';
import 'package:status/module/loading/loading_view.dart';

extension StreamSubscriptionExtension on StreamSubscription {
  void disposed({@required CompositeSubscription by}) {
    by.add(this);
  }
}

extension ObservableExtension<T> on Observable<T> {
  Observable<T> debug() {
    return this.doOnData(print);
  }

  Observable<T> asButton() {
    return this.throttle((_) => TimerStream(true, const Duration(seconds: 1)));
  }

  Observable<T> isNotNull() {
    return this.where((w) => w != null);
  }

  Observable<T> onErrorResumeEmpty() {
    return this.onErrorResume((ex) {
      print(ex);
      return Observable.empty();
    });
  }

  Observable<D> flatMapFuture<D>(Future<D> mapper(T value)) {
    return this.flatMap((T value) => Observable.fromFuture(mapper(value)));
  }

  Observable<T> indicators(
    BuildContext context, {
    String title,
    String description,
  }) {
    return this
        .doOnListen(
          () => Loading.show(
            context,
            title: title,
            description: description,
          ),
        )
        .doOnData((_) => Loading.hide(context))
        .doOnError((_, __) => Loading.hide(context));
  }

  Observable<T> indicatorsWithoutContext({
    String title,
    String description,
  }) {
    var context = AppComponentState.globalContext;

    return indicators(
      context,
      title: title,
      description: description,
    );
  }

  StreamSubscription bind({@required Sink<T> to}) {
    return this.listen(to.add);
  }
}
