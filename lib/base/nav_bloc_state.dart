import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:status/base/base_bloc.dart';
import 'package:status/enums/nav.dart';
import 'package:status/widget/rx/rx_bottom_navigation.dart';

abstract class NavBlocState extends BaseBloc {
  final Nav navType;
  final RxBottomNavigation rxNav;

  Observable<Nav> get navFirstSelected =>
      rxNav.curItemSelected.where((item) => item == navType).take(1);

  NavBlocState(
    BuildContext context, {
    @required this.navType,
    @required this.rxNav,
  }) : super(context);
}
