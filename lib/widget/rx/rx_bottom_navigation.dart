
import 'package:rxdart/rxdart.dart';
import 'package:status/enums/nav.dart';

import 'rx.dart';

class RxBottomNavigation extends Rx<Nav> {
  final List<Nav> items;
  final int initIndex;
  Nav get itemSelectedAt => items[this.initIndex];

  RxBottomNavigation(this.items, {this.initIndex = 0});

  Observable<Nav> get curItemSelected =>
      stream.startWith(itemSelectedAt).distinct();

  Observable<int> get curIndexSelected => curItemSelected.map(items.indexOf);
}
