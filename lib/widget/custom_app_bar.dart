import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:status/widget/safe_area_color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color appBarColor;
  final Widget child;

  const CustomAppBar({
    Key key,
    this.height = 40,
    this.appBarColor = Colors.white,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeAreaColor(
      color: appBarColor,
      child: child ?? Container(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
