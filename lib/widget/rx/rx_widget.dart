import 'package:flutter/widgets.dart';

import 'rx.dart';

abstract class RxWidget<T extends Rx> extends StatelessWidget {
  final T rx;

  RxWidget(this.rx, {Key key}) : super(key: key);
}
