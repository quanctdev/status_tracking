import 'package:status/module/auth/auth_bloc.dart';
import 'package:status/network/repository.dart';

abstract class Application {
  Repository repository;
  AuthBloc authBloc;

  void onCreate();

  void onDestroy();
}
