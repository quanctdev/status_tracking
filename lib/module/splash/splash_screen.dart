import 'package:flutter/material.dart';
import 'package:status/base/bloc_state.dart';
import 'package:status/resource/app_colors.dart';

import 'splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends BlocState<SplashScreen, SplashBloc> {
  @override
  SplashBloc createBloc(BuildContext context) {
    return SplashBloc(context);
  }

  @override
  Widget onCreateView(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Image(
        width: 18,
        height: 18,
        image: AssetImage('images/ic_launcher.png'),
      ),
    );
  }
}
