import 'package:flutter/material.dart';
import 'package:status/enums/nav.dart';
import 'package:status/widget/rx/rx_bottom_navigation.dart';

import 'rx/rx_widget.dart';

class BottomNavigationRxWidget extends RxWidget<RxBottomNavigation> {
  BottomNavigationRxWidget(RxBottomNavigation rx) : super(rx);

  Widget renderItem(BuildContext context, Nav item, Color color) {
    var icon = item.assetRes;

    return Expanded(
      child: Material(
        child: InkWell(
          onTap: () => rx.sink.add(item),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 24, color: color),
              Text(
                item.getTitle(context),
                style: TextStyle(fontSize: 12, color: color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }

  renderBottomNavigation(BuildContext context) {
    return new Container(
      width: double.infinity,
      decoration:
          BoxDecoration(color: Theme.of(context).canvasColor, boxShadow: [
        BoxShadow(color: Colors.black12, offset: Offset(0, -1), blurRadius: 8)
      ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 50,
            child: StreamBuilder<Nav>(
                stream: rx.curItemSelected,
                initialData: rx.itemSelectedAt,
                builder: (context, snapshot) {
                  Nav current = snapshot.data;
                  if (current == null) return null;
                  return new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: rx.items.map((item) {
                      var color = current == item
                          ? Color(0xFF5E76FA)
                          : Color(0XffA2A2A2);
                      return renderItem(context, item, color);
                    }).toList(),
                  );
                }),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return renderBottomNavigation(context);
  }
}
