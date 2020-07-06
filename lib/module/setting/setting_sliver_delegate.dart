import 'package:flutter/material.dart';
import 'package:status/app/app_provider.dart';
import 'package:status/module/auth/auth_bloc.dart';
import 'package:status/resource/app_colors.dart';
import 'package:status/widget/button_with_border_rx_widget.dart';
import 'package:status/base/extension/extension.dart';

class SettingSliverDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final double expandedHeight;

  SettingSliverDelegate({
    @required this.title,
    @required this.expandedHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return Container(
      height: appBarSize < kToolbarHeight ? kToolbarHeight : appBarSize,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
          image: AssetImage("images/img_login.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .apply(color: AppColors.white),
                      ),
                    ),
                    SizedBox(height: 5 * percent),
                    Expanded(
                      child: Opacity(
                        opacity: percent,
                        child: Text(
                          context.string("link_description"),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .apply(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (c, a) => ScaleTransition(child: c, scale: a),
                child: ButtonWithBorderRxWidget(
                  null,
                  onPressed: () {
                    AuthBloc authBloc = AppProvider.authBloc(context);
                    authBloc.signInWithGoogle();
                  },
                  color: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  textStyle: Theme.of(context)
                      .textTheme
                      .button
                      .apply(color: AppColors.primaryLight),
                  title: context.string("link"),
                ),
                // child: Center(
                //   child: CircularProgressIndicator(
                //       backgroundColor: AppColors.white),
                // ),
              ),
            ],
          )),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
