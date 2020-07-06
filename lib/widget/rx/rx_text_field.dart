import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:rxdart/rxdart.dart';
import 'package:status/widget/rx/rx_event.dart';

import 'rx.dart';

enum TextFieldAction { TEXT_CHANGES, TEXT_FIELD_SUBMITTED, TEXT_FIELD_CLEAN }

class RxTextField extends RxEvent<TextFieldAction> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focus = FocusNode();
  final String initialValue;

  Rx<bool> rxFocus = Rx<bool>();

  RxTextField({this.initialValue = ""}) {
    controller.addListener(() {
      pushEvent(TextFieldAction.TEXT_CHANGES, value: controller.text);
    });

    focus.addListener(() => rxFocus.sink.add(focus.hasFocus));

    controller.text = initialValue;
    if (initialValue.isEmpty) {
      pushEvent(TextFieldAction.TEXT_CHANGES, value: initialValue);
    }
  }

  Observable<bool> get isEnableCleanText => Observable.combineLatest2(
      textChanges,
      rxFocus.stream,
      (String text, bool isFocus) => text.isNotEmpty && isFocus);

  Observable<String> get textChanges =>
      catchEvent<String>(TextFieldAction.TEXT_CHANGES).distinct();

  Observable<String> get submitted =>
      catchEvent<String>(TextFieldAction.TEXT_FIELD_SUBMITTED);

  Observable<String> get cleaned =>
      catchEvent<String>(TextFieldAction.TEXT_FIELD_CLEAN);

  void textFieldSubmitted(String term) {
    pushEvent(TextFieldAction.TEXT_FIELD_SUBMITTED, value: term);
  }

  void textFieldClean() {
    controller.clear();
    pushEvent(TextFieldAction.TEXT_FIELD_CLEAN, value: "");
  }

  @override
  void dispose() {
    rxFocus.dispose();
    controller.dispose();
    super.dispose();
  }
}
