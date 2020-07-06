import 'package:flutter/material.dart';
import 'package:status/base/bloc_state.dart';
import 'package:status/module/loading/loading_bloc.dart';

class Loading extends StatefulWidget {
  final String title;
  final String description;

  Loading({Key key, this.title, this.description}) : super(key: key);
  @override
  _LoadingState createState() => _LoadingState();

  static void show(BuildContext ct, {String title, String description}) {
    showGeneralDialog(
        useRootNavigator: true,
        barrierColor: Color(0x21000000),
        transitionBuilder: (ct, a1, a2, widget) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: Loading(title: title, description: description),
          );
        },
        transitionDuration: Duration(milliseconds: 150),
        barrierDismissible: false,
        context: ct,
        barrierLabel: "",
        pageBuilder: (ct, animation1, animation2) {
          return Container();
        });
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class _LoadingState extends BlocState<Loading, LoadingBloc> {
  @override
  LoadingBloc createBloc(BuildContext context) {
    return LoadingBloc(
      context,
      title: widget.title,
      description: widget.description,
    );
  }

  @override
  Widget onCreateView(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  StreamBuilder<String>(
                      stream: bloc.titleStream,
                      initialData: "",
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? "",
                          style: Theme.of(context).textTheme.headline6,
                        );
                      }),
                  StreamBuilder<String>(
                      stream: bloc.descriptionStream,
                      initialData: "",
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? "",
                          style: Theme.of(context).textTheme.subtitle2,
                        );
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
