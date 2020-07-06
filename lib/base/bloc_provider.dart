import 'package:flutter/material.dart';

import 'base_bloc.dart';

class BlocProvider<T extends BaseBloc> extends InheritedWidget {
  final T bloc;

  static T of<T extends BaseBloc>(BuildContext context) {
    BlocProvider<T> provider =
        context.dependOnInheritedWidgetOfExactType<BlocProvider<T>>();
    if (provider == null) {
      throw StateError('Cannot get provider');
    }
    return provider.bloc;
  }

  const BlocProvider({
    Key key,
    @required Widget child,
    @required this.bloc,
  })  : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(BlocProvider old) => bloc != old.bloc;
}
