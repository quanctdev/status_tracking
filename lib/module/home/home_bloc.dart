import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:status/app/app_provider.dart';
import 'package:status/app/router.dart';
import 'package:status/model/user.dart';
import 'package:status/module/auth/auth_bloc.dart';
import 'package:status/widget/rx/rx_drp.dart';
import 'package:status/base/nav_bloc_state.dart';
import 'package:status/enums/nav.dart';
import 'package:status/model/tracking_info.dart';
import 'package:status/widget/rx/rx_bottom_navigation.dart';
import 'package:status/base/extension/extension.dart';

class HomeBloc extends NavBlocState {
  static const int EVENT_SHOW_DIALOG_ADD_URL = 1;
  static const int EVENT_DELETE_URL_TRACKING = 2;

  RxDrp<List<TrackingInfo>> rxTrackingInfo = RxDrp();

  HomeBloc(BuildContext context, RxBottomNavigation rxNav)
      : super(context, rxNav: rxNav, navType: Nav.HOME) {
    AuthBloc authBloc = AppProvider.authBloc(context);

    Observable.combineLatest3(
      rxTrackingInfo.retry.startWith(null),
      navFirstSelected,
      authBloc.userStream,
      (_, __, User user) {
        var ob = db
            .createAnonymousUser()
            .onErrorResumeEmpty()
            .flatMap((_) => db.getTrackingInfo());

        if (user?.uid != null) {
          ob = db.getTrackingInfo(uid: user.uid);
        }

        return ob;
      },
    )
        .flatMap((getTrackingInfo) => getTrackingInfo)
        .withLatestFrom(rxTrackingInfo.stream, updateTrackingInfo)
        .listen(rxTrackingInfo.sink.add, onError: rxTrackingInfo.sinkError)
        .disposed(by: disposeBag);

    catchEvent(EVENT_SHOW_DIALOG_ADD_URL)
        .asButton()
        .flatMap((_) => _showDialogAddUrl())
        .listen((_) => print("Add url success"), onError: print)
        .disposed(by: disposeBag);

    catchEvent<TrackingInfo>(EVENT_DELETE_URL_TRACKING)
        .asButton()
        .withLatestFrom(authBloc.userStream, _wapData)
        .flatMap(_deleteUrlTrackingForUser)
        .listen((_) => print("Delete url success"), onError: print)
        .disposed(by: disposeBag);
  }

  Map<String, String> _wapData(TrackingInfo info, User user) {
    return {
      "url": info.url,
      "uid": user?.uid,
    };
  }

  Observable<void> _deleteUrlTrackingForUser(Map<String, String> info) {
    String url = info["url"];
    String uid = info["uid"];
    return db.deleteUrlTrackingForUser(url, uid: uid);
  }

  Drp<List<TrackingInfo>> updateTrackingInfo(
      List<TrackingInfo> newData, Drp<List<TrackingInfo>> response) {
    // var oldData = response.data ?? [];
    // var sameData = oldData.firstWhere((info) => info.url == newData.url, orElse: () => null);

    // if (sameData == null) {
    //   oldData.add(newData);
    // } else {
    //   sameData.lastTimeTracking = newData.lastTimeTracking;
    //   sameData.statusCode = newData.statusCode;
    //   sameData.statusMessage = newData.statusMessage;
    // }

    return Drp.data(newData);
  }

  Observable<String> _showDialogAddUrl() {
    Future<String> openScreen = Navigator.of(context, rootNavigator: true)
        .pushNamed<String>(Router.ADD_TRACKING);

    return Observable.fromFuture(openScreen);
  }

  void showHistory(TrackingInfo info) {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(Router.TRACKING_HISTORY, arguments: info);
  }

  void showDialogAddUrl() {
    pushEvent(EVENT_SHOW_DIALOG_ADD_URL);
  }

  void deleteTrackingUrl(TrackingInfo info) {
    pushEvent<TrackingInfo>(EVENT_DELETE_URL_TRACKING, data: info);
  }

  @override
  void dispose() {
    rxTrackingInfo.dispose();
    super.dispose();
  }
}
