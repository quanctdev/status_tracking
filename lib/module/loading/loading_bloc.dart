import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:status/base/base_bloc.dart';
import 'package:status/widget/rx/rx.dart';

class LoadingBloc extends BaseBloc {
  Rx<String> _title = Rx(initValue: "Đang tải");
  Rx<String> _description = Rx(initValue: 'Vui lòng chờ!');

  Observable<String> get titleStream => _title.stream;
  Observable<String> get descriptionStream => _description.stream;

  LoadingBloc(BuildContext context, {String title, String description})
      : super(context) {
    updateTitle(title);
    updateDescription(description);
  }

  void updateTitle(String title) {
    if (title == null) return;
    _title.sink.add(title);
  }

  void updateDescription(String description) {
    if (description == null) return;
    _description.sink.add(description);
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}
