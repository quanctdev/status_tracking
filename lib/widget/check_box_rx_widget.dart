import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:status/widget/rx/rx_checkbox.dart';
import 'package:status/widget/rx/rx_widget.dart';

class CheckBoxRxWidget extends RxWidget<RxCheckBox> {
  CheckBoxRxWidget(
    RxCheckBox rx, {
    Key key,
  }) : super(rx, key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.7,
      child: StreamBuilder<Object>(
          initialData: rx?.isChecked ?? true,
          stream: rx?.selected,
          builder: (context, snapshot) {
            return CupertinoSwitch(
              activeColor: Theme.of(context).primaryColor,
              dragStartBehavior: DragStartBehavior.down,
              onChanged: (bool value) => rx?.sink?.add(null),
              value: snapshot.data,
            );
          }),
    );
  }
}
