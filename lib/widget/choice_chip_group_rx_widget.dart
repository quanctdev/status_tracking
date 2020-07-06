import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:status/resource/app_colors.dart';
import 'package:status/widget/rx/rx_choice_chip_group.dart';
import 'package:status/widget/rx/rx_widget.dart';

class ChoiceChipGroupRxWidget extends RxWidget<RxChoiceChipGroup> {
  ChoiceChipGroupRxWidget(
    RxChoiceChipGroup rx, {
    Key key,
  }) : super(rx, key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: rx?.position,
        initialData: 0,
        builder: (context, snapshot) {
          return Row(
            children: List<Widget>.generate(
              rx.chips.length,
              (int index) {
                bool selected = snapshot.data == index;
                Color selectColor =
                    selected ? AppColors.primaryLight : AppColors.background;
                Color titleColor =
                    selected ? AppColors.primaryLight : AppColors.black;
                Choice chip = rx.chips[index];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Material(
                      color: AppColors.white,
                      child: InkWell(
                        onTap: () => rx?.sink?.add(index),
                        child: Container(
                            height: 185,
                            padding: EdgeInsets.only(left: 4, right: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: selectColor),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                Image(
                                    image: AssetImage(chip.icon), height: 120),
                                Text(
                                  chip.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .apply(color: titleColor),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  chip.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .apply(color: AppColors.background),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          );
        });
  }
}
