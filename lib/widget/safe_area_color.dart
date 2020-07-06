import 'package:flutter/material.dart';

class SafeAreaColor extends StatelessWidget {
  final Widget child;
  final Color color;
  final BorderRadiusGeometry borderRadius;
  const SafeAreaColor({
    Key key,
    @required this.child,
    @required this.color,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: SafeArea(bottom: false, child: child),
    );
  }
}
