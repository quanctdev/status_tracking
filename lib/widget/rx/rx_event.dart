import 'package:rxdart/rxdart.dart';
import 'package:status/widget/rx/event.dart';

import 'rx.dart';

class RxEvent<T> extends Rx<Event<T, Object>> {
  void pushEvent<V>(T event, {V value}) {
    sink.add(Event(event, value: value));
  }

  Observable<V> catchEvent<V>(T type) => stream
      .where((event) => event != null && event.type == type)
      .map((event) => event.value);
}
