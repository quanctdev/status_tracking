import 'package:flutter/material.dart';
import 'package:status/widget/rx/rx_text_field.dart';

import 'edit_text_rx_widget.dart';

class AppEditTextRxWidget extends EditTextRxWidget {
  final String suffixText;
  final String hintText;
  final bool autofocus;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final TextInputAction textInputAction;
  final double fontSize;

  final String title;
  final String description;

  AppEditTextRxWidget(
    RxTextField rx, {
    this.hintText,
    this.suffixText = "",
    this.autofocus = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.textInputAction,
    this.fontSize = 18,
    this.title,
    this.description,
    Key key,
  }) : super(
          rx,
          key: key,
          hintText: hintText,
          suffixText: suffixText,
          autofocus: autofocus,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          textInputAction: textInputAction,
          fontSize: fontSize,
        );

  Widget _renderTitle(BuildContext context) {
    return title == null
        ? Container()
        : Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          );
  }

  Widget _renderDescription(BuildContext context) {
    return description == null
        ? Container()
        : Text(
            description,
            style: Theme.of(context).textTheme.subtitle1,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _renderTitle(context),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4),
          child: super.build(context),
        ),
        SizedBox(height: 5),
        _renderDescription(context),
      ],
    );
  }
}
