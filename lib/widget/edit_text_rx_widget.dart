import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:status/resource/app_colors.dart';

import 'rx/rx_text_field.dart';
import 'rx/rx_widget.dart';

class EditTextRxWidget extends RxWidget<RxTextField> {
  EditTextRxWidget(
    RxTextField rx, {
    this.hintText,
    this.suffixText = "",
    this.autofocus = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.textInputAction,
    this.fontSize = 18,
    Key key,
  }) : super(rx, key: key);

  final String suffixText;
  final String hintText;
  final bool autofocus;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled;
  final TextInputAction textInputAction;
  final double fontSize;

  final BoxDecoration _edtBackground = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    border: Border.all(
      color: AppColors.background,
      width: 1,
    ),
    color: Colors.white,
  );

  Widget renderEdtInput(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextFormField(
            focusNode: rx.focus,
            onFieldSubmitted: rx.textFieldSubmitted,
            textInputAction: textInputAction,
            enabled: enabled,
            keyboardType: keyboardType,
            obscureText: obscureText,
            controller: rx.controller,
            autofocus: autofocus,
            style: Theme.of(context).textTheme.headline3,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: Theme.of(context)
                  .textTheme
                  .headline3
                  .apply(color: AppColors.background),
              contentPadding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
            ),
          ),
        ),
        StreamBuilder<bool>(
            stream: rx.isEnableCleanText,
            initialData: false,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return _renderSuffix(snapshot);
            }),
      ],
    );
  }

  Widget _renderIconCleanEdt() {
    return InkWell(
      onTap: () => WidgetsBinding.instance.addPostFrameCallback((_) {
        rx.textFieldClean();
      }),
      child: Icon(
        Icons.cancel,
        size: 18,
        color: Color(0xffa2a2a2),
      ),
    );
  }

  Widget _renderSuffix(AsyncSnapshot<bool> snapshot) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          suffixText,
          style: TextStyle(fontSize: fontSize, color: Color(0xFFa2a2a2)),
        ),
        SizedBox(width: 6),
        snapshot.data ? _renderIconCleanEdt() : Container(),
        SizedBox(width: 6),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 40,
        decoration: _edtBackground,
        child: Center(
          child: renderEdtInput(context),
        ));
  }
}
