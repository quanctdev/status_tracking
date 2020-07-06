import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:status/model/tracking_history.dart';
import 'package:status/model/tracking_info.dart';
import 'package:status/model/user.dart';

abstract class Repository {
  Observable<List<TrackingInfo>> getTrackingInfo({String uid});

  Observable<List<TrackingHistory>> getTrackingHistoryByInfo(
    TrackingInfo info,
    DocumentSnapshot lastDoc,
  );

  Observable<bool> createAnonymousUser();

  Observable<void> addNewUrlTrackingForUser(String url, {String uid});

  Observable<void> deleteUrlTrackingForUser(String url, {String uid});

  Observable<User> signedIn(String uid);

  Future<User> getUserByUid(String uid);

  Observable<void> signOut(String uid);
}
