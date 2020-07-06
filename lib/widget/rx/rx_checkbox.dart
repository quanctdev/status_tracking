import 'package:rxdart/rxdart.dart';

import 'rx.dart';

class RxCheckBox extends Rx<void> {
  RxCheckBox({
    this.isChecked = false,
  });

  final bool isChecked;

  Observable<bool> get selected =>
      stream.scan((acc, curr, i) => !acc, isChecked).startWith(isChecked);
}
