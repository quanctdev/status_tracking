import 'package:flutter/widgets.dart';
import 'package:status/base/base_bloc.dart';

import 'alert_action.dart';

class AlertBloc extends BaseBloc {
  AlertBloc(BuildContext context) : super(context);

  void onCancel() {
    Navigator.of(context).pop(AlertAction.CANCEL);
  }

  void onDone() {
    Navigator.of(context).pop(AlertAction.DONE);
  }
}
