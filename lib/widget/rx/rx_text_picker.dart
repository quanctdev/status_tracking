import 'package:rxdart/rxdart.dart';

import 'rx.dart';

class RxTextPicker extends Rx<String> {
  Observable<String> get textChanges => stream.distinct();

  set text(String text) => sink.add(text);
}
