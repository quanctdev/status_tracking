import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:status/resource/app_colors.dart';
import 'package:status/widget/rx/rx_button.dart';
import 'package:status/widget/rx/rx_widget.dart';

class ButtonWithBorderRxWidget extends RxWidget<RxButton> {
  ButtonWithBorderRxWidget(
    RxButton rx, {
    this.title,
    this.height = 40,
    this.width,
    this.color,
    this.onPressed,
    this.textStyle,
    this.shape,
    Key key,
  }) : super(rx, key: key);

  final String title;
  final double height;
  final double width;
  final Color color;
  final VoidCallback onPressed;
  final TextStyle textStyle;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    var shapeBoder = shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        );

    return Container(
      width: width,
      height: height,
      child: Material(
        color: color ?? Theme.of(context).buttonColor,
        shape: shapeBoder,
        child: MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              if (rx != null) {
                rx.sink.add(null);
              } else if (onPressed != null) {
                onPressed();
              }
            },
            child: Text(
              title,
              style: textStyle ??
                  Theme.of(context)
                      .textTheme
                      .headline3
                      .apply(color: AppColors.white),
            )),
      ),
    );
  }
}
