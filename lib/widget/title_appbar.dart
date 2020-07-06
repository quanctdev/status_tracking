import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:status/resource/app_colors.dart';
import 'package:status/widget/safe_area_color.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final bool haveButtonBack;
  final Color color;
  final Widget widgetBack;
  final Widget drawableRight;
  final Color titleColor;
  final VoidCallback drawableRightClick;

  const TitleAppBar(
      {Key key,
      this.height = kToolbarHeight,
      @required this.title,
      this.haveButtonBack = false,
      this.color = Colors.white,
      this.widgetBack,
      this.titleColor = Colors.black,
      this.drawableRightClick,
      this.drawableRight})
      : super(key: key);

  Widget _renderBackButton(BuildContext context) {
    Widget defaultWidget = Icon(
      Icons.arrow_back,
      color: AppColors.white,
      size: 28,
    );

    Widget widget = widgetBack == null ? defaultWidget : widgetBack;

    return haveButtonBack == false
        ? Container()
        : Material(
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25.0),
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget,
              ),
              onTap: () => Navigator.pop(context),
            ),
          );
  }

  Widget _renderDrawableRight() {
    Widget defaultWidget = Container();

    return drawableRight == null
        ? defaultWidget
        : Material(
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(25.0),
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: drawableRight,
              ),
              onTap: () {
                if (drawableRightClick != null) drawableRightClick();
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaColor(
      color: color,
      child: Container(
        color: color,
        child: Row(
          children: <Widget>[
            _renderBackButton(context),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .apply(color: AppColors.white),
              ),
            ),
            _renderDrawableRight(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
