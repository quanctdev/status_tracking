import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:status/widget/safe_area_color.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final Color color;

  const HomeAppBar({
    Key key,
    this.height = 40,
    @required this.title,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeAreaColor(
      color: color,
      child: Center(
          child: Text(title, style: Theme.of(context).textTheme.headline4,),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
