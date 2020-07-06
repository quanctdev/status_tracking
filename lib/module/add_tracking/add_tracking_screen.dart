import 'package:flutter/material.dart';
import 'package:status/base/bloc_state.dart';
import 'package:status/resource/app_colors.dart';
import 'package:status/widget/app_edit_text_rx_widget.dart';
import 'package:status/widget/button_with_border_rx_widget.dart';
import 'package:status/widget/choice_chip_group_rx_widget.dart';
import 'package:status/widget/disable_scroll_glow.dart';
import 'package:status/widget/title_appbar.dart';
import 'package:status/base/extension/extension.dart';

import 'add_tracking_bloc.dart';

class AddTrackingScreen extends StatefulWidget {
  AddTrackingScreen({Key key}) : super(key: key);
  @override
  _DialogAddUrlScreenScreenState createState() =>
      _DialogAddUrlScreenScreenState();
}

class _DialogAddUrlScreenScreenState
    extends BlocState<AddTrackingScreen, AddTrackingBloc> {
  @override
  AddTrackingBloc createBloc(BuildContext context) {
    return AddTrackingBloc(context);
  }

  @override
  Widget onCreateView(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        title: context.string("add_url_title"),
        color: AppColors.primaryLight,
        haveButtonBack: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.white,
        constraints: new BoxConstraints.expand(),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ScrollConfiguration(
          behavior: DisableScrollGlow(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 16),
                Text(
                  "Select test type",
                  style: Theme.of(context).textTheme.headline6,
                ),
                ChoiceChipGroupRxWidget(bloc.chips),
                SizedBox(height: 15),
                AppEditTextRxWidget(
                  bloc.edtNewUrl,
                  hintText: context.string("add_url_hint"),
                  title: "Full URL",
                  description: context.string("url_parameters"),
                ),
                SizedBox(height: 25),
                renderBtnAddUrl(),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget renderBtnAddUrl() {
    return StreamBuilder<bool>(
        stream: bloc.isValidateUrlStream,
        initialData: false,
        builder: (context, snapshot) {
          bool isValidateUrl = snapshot.data;
          Color bg = isValidateUrl
              ? Theme.of(context).primaryColor
              : Theme.of(context).dividerColor;

          return ButtonWithBorderRxWidget(
            bloc.btnAddUrl,
            color: bg,
            title: "Add",
            width: double.infinity,
          );
        });
  }
}
