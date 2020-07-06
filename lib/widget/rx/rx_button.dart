import 'package:rxdart/rxdart.dart';
import 'package:status/base/extension/extension.dart';

import 'rx.dart';

class RxButton extends Rx<void> {
  Observable<void> get tap => stream.asButton();
}
