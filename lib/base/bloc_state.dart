import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:status/base/base_bloc.dart';

import 'bloc_provider.dart';

abstract class BlocState<W extends StatefulWidget, T extends BaseBloc>
    extends State<W> {
  T createBloc(BuildContext context);

  Widget onCreateView(BuildContext context);

  void onViewCreated(BuildContext context) {
    _bloc.pushTransactionCompleted();
  }

  T _bloc;

  T get bloc => _bloc;

  @override
  void initState() {
    super.initState();

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      print("onViewCreated: $this");
      SchedulerBinding.instance.addPostFrameCallback((_) => onViewCreated(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = createBloc(context);
    }

    // else if (Env.value.useHotReloadForRx) {
    //   _bloc.compositeSubscription.clear();
    //   _bloc = createBloc(context);
    // }

    return BlocProvider(
      bloc: _bloc,
      child: onCreateView(context),
    );
  }

  @override
  void dispose() {
    print("dispose: $this");

    _bloc.dispose();
    super.dispose();
  }
}
