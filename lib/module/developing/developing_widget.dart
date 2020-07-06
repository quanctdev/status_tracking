import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const NotificationWidget(
      {Key key,
      this.image = 'images/img_developing.png',
      this.title = '',
      this.description = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: new BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage(image)),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
