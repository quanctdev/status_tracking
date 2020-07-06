import 'package:rxdart/rxdart.dart';
import 'package:status/base/extension/extension.dart';

class Rx<T> {
  Subject<T> subject;

  Rx({T initValue, useNullValue = false}) {
    if (initValue != null || useNullValue) {
      subject = BehaviorSubject.seeded(initValue);
    } else {
      subject = BehaviorSubject();
    }
  }

  Observable<T> get stream => subject.stream;

  Sink<T> get sink => subject.sink;

  T get value => subject.as<BehaviorSubject>()?.stream?.value;

  // Subject<T> get subject => _subject;

  // set subject(Subject<T> currSubject) {
  //   _subject = currSubject;
  // }

  void dispose() {
    subject.close();
  }
}
