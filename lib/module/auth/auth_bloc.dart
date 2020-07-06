import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:status/app/app_component.dart';
import 'package:status/base/base_bloc.dart';
import 'package:status/base/extension/extension.dart';
import 'package:status/model/user.dart';
import 'package:status/module/alert/alert_mixin.dart';
import 'package:status/network/repository.dart';
import 'package:status/widget/rx/rx.dart';

class AuthBloc extends RxBloc with Alert {
  static const int EVENT_SIGN_IN_WITH_GOOGLE = 1;
  static const int EVENT_SIGN_OUT = 2;

  final Repository repository;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx _error = Rx();
  Stream get errorStream => _error.stream;

  Rx<User> _user = Rx();
  Stream<User> get userStream => _user.stream;

  AuthBloc(this.repository) {
    //Wait to complete through the interface initializer. This could become a bug
    Observable.timer(null, const Duration(milliseconds: 500))
        .flatMapFuture((_) => _initialUser())
        .listen(_user.sink.add, onError: _error.sink.add)
        .disposed(by: disposeBag);

    errorStream.listen((err) {
      var ct = AppComponentState.globalContext;
      showErrorAlert(ct, err);
    }).disposed(by: disposeBag);

    catchEvent(EVENT_SIGN_IN_WITH_GOOGLE)
        .asButton()
        .flatMap((_) => Observable.fromFuture(_googleSignIn.signIn()))
        // Observable.fromFuture(_googleSignIn.signIn())
        .isNotNull()
        .flatMap((account) => Observable.fromFuture(account.authentication))
        .flatMap(_signInWithCredential)
        .map((authResult) => authResult.user)
        .flatMap((firebaseUser) =>
            repository.signedIn(firebaseUser.uid).indicatorsWithoutContext())
        .listen(_user.sink.add, onError: _error.sink.add)
        .disposed(by: disposeBag);

    catchEvent(EVENT_SIGN_OUT)
        .asButton()
        .withLatestFrom(
            userStream, (_, User user) => repository.signOut(user.uid))
        .flatMap((signOut) => signOut.indicatorsWithoutContext())
        .listen((_) => _user.sink.add(null), onError: _error.sink.add)
        .disposed(by: disposeBag);
  }

  Future<User> _initialUser() async {
    User user;
    var firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      var uid = firebaseUser.uid;
      user = await repository.getUserByUid(uid);
    }

    return user;
  }

  Observable<AuthResult> _signInWithCredential(GoogleSignInAuthentication au) {
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: au.accessToken,
      idToken: au.idToken,
    );

    return Observable.fromFuture(_auth.signInWithCredential(credential));
  }

  void signInWithGoogle() {
    pushEvent(EVENT_SIGN_IN_WITH_GOOGLE);
  }

  void signOut() {
    pushEvent(EVENT_SIGN_OUT);
  }

  @override
  void dispose() {
    _error.dispose();
    _user.dispose();
    super.dispose();
  }
}
