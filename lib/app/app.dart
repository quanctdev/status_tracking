import 'package:status/module/auth/auth_bloc.dart';
import 'package:status/network/firestore_repository.dart';

import 'application.dart';

class App extends Application {
  @override
  Future onCreate() async {
    repository = FirestoreRepository();
    authBloc = AuthBloc(repository);
  }

  @override
  void onDestroy() {
    authBloc.dispose();
  }
}
