import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'rx.dart';

class Choice {
  String title;
  String description;
  String icon;

  Choice({this.title, this.description, this.icon});
}

class RxChoiceChipGroup extends Rx<int> {
  final List<Choice> chips;

  RxChoiceChipGroup({
    @required this.chips,
    int initValue,
  }) : super(initValue: initValue);

  Observable<int> get position => stream;
}
