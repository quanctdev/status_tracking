import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:status/app/app_provider.dart';
import 'package:status/base/base_bloc.dart';
import 'package:status/model/user.dart';
import 'package:status/module/alert/alert_action.dart';
import 'package:status/module/alert/alert_controller.dart';
import 'package:status/module/auth/auth_bloc.dart';
import 'package:status/module/loading/loading_view.dart';
import 'package:status/widget/rx/rx_button.dart';
import 'package:status/widget/rx/rx_choice_chip_group.dart';
import 'package:status/widget/rx/rx_text_field.dart';
import 'package:status/base/extension/extension.dart';

class AddTrackingBloc extends BaseBloc {
  static const int EVENT_ADD_URL = 1;

  RxTextField edtNewUrl;
  RxButton btnAddUrl;
  RxChoiceChipGroup chips;
  Observable<bool> isValidateUrlStream;

  AddTrackingBloc(BuildContext context) : super(context) {
    AuthBloc authBloc = AppProvider.authBloc(context);

    edtNewUrl = RxTextField();
    btnAddUrl = RxButton();
    chips = RxChoiceChipGroup(initValue: 0, chips: <Choice>[
      Choice(
          title: "HTTPS",
          description: "HyperText Transfer Protocol Secure",
          icon: "images/ic_https.png"),
      Choice(
          title: "HTTP",
          description: "HyperText Transfer Protocol",
          icon: "images/ic_http.png"),
    ]);

    Observable<String> urlStream = Observable.combineLatest2(
      chips.position,
      edtNewUrl.textChanges,
      _createUrl,
    ).asBroadcastStream();

    isValidateUrlStream = urlStream.map(_isValidateUrl);

    btnAddUrl.tap
        .withLatestFrom(isValidateUrlStream, (_, isValidate) => isValidate)
        .where((isValidate) => isValidate)
        .withLatestFrom2(
          urlStream,
          authBloc.userStream,
          (_, url, User user) =>
              db.addNewUrlTrackingForUser(url, uid: user?.uid),
        )
        .flatMap(
          (addTracking) =>
              addTracking.indicators(context, title: 'Đang thêm mới'),
        )
        .flatMapFuture(
          (_) => AlertController.showOption(
            context,
            title: context.string('add_tracking_success_title'),
            description: context.string('add_tracking_success_description'),
          ),
        )
        .listen(_handleAction, onError: handleError)
        .disposed(by: disposeBag);
  }

  void _handleAction(int action) {
    if (action == AlertAction.DONE)
      edtNewUrl.textFieldClean();
    else if (action == AlertAction.CANCEL) AlertController.dismiss(context);
  }

  void addUrl() {
    pushEvent(EVENT_ADD_URL);
  }

  bool _isValidateUrl(url) {
    var sr =
        r'^https?:\/\/(www.)?[-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-z]{2,5}(:[0-9]{1,5})?\/$';
    RegExp regExp = new RegExp(sr);
    return regExp.hasMatch(url);
  }

  String _createUrl(int position, String url) {
    if (url.length > 0 && url[url.length - 1] != '/') {
      url = '$url/';
    }
    String type = position == 0 ? "https://" : "http://";
    return type + url;
  }

  @override
  void dispose() {
    edtNewUrl.dispose();
    btnAddUrl.dispose();
    chips.dispose();
    super.dispose();
  }
}
