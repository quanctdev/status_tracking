import 'package:rxdart/rxdart.dart';

import 'rx.dart';

class RxFilter<T> extends Rx<T> {
  Observable<T> get filter => stream.cast<T>();
}