import 'package:flutter/material.dart';
import 'package:status/base/bloc_state.dart';
import 'package:status/module/alert/alert_action.dart';
import 'package:status/resource/app_colors.dart';
import 'package:status/widget/button_with_border_rx_widget.dart';

import 'alert_bloc.dart';

class AlertWidget extends StatefulWidget {
  final int action;
  final String title;
  final String description;
  final String image;

  AlertWidget({
    Key key,
    this.action = AlertAction.NONE,
    @required this.title,
    @required this.description,
    this.image,
  }) : super(key: key);
  @override
  _AlertWidgetState createState() => _AlertWidgetState();
}

class _AlertWidgetState extends BlocState<AlertWidget, AlertBloc> {
  @override
  AlertBloc createBloc(BuildContext context) {
    return AlertBloc(context);
  }

  Widget _renderDoneButton() {
    bool isRender = (widget.action & AlertAction.DONE) == AlertAction.DONE;
    Widget button = Container();

    if (isRender) {
      button = Container(
        margin: EdgeInsets.only(left: 10),
        child: ButtonWithBorderRxWidget(
          null,
          onPressed: () => bloc.onDone(),
          textStyle:
              Theme.of(context).textTheme.button.apply(color: AppColors.white),
          title: "Tiếp tục",
        ),
      );
    }

    return button;
  }

  Widget _renderCancelButton() {
    bool isRender = (widget.action & AlertAction.CANCEL) == AlertAction.CANCEL;
    Widget button = Container();

    if (isRender) {
      button = Container(
        margin: EdgeInsets.only(left: 10),
        child: ButtonWithBorderRxWidget(
          null,
          onPressed: () => bloc.onCancel(),
          color: AppColors.white,
          textStyle: Theme.of(context)
              .textTheme
              .button
              .apply(color: AppColors.primaryLight),
          title: "Quay lại",
        ),
      );
    }

    return button;
  }

  Widget _renderImageHeader() {
    bool isRender = widget.image != null;
    Widget header = Container();

    if (isRender) {
      header = Image(image: AssetImage(widget.image));
    }

    return header;
  }

  @override
  Widget onCreateView(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _renderImageHeader(),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 15),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.subtitle2,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _renderCancelButton(),
                      _renderDoneButton()
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
