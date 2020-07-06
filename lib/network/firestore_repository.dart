import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:status/app/util.dart';
import 'package:status/model/device_signed_in.dart';
import 'package:status/model/tracking_history.dart';
import 'package:status/model/tracking_info.dart';
import 'package:status/model/user.dart';
import 'package:status/network/repository.dart';
import 'package:status/plugin/plugin.dart';

import 'firebase_manager.dart';
import 'firestore_path.dart';

class FirestoreRepository extends FirebaseManager implements Repository {
  Stream<QuerySnapshot> _getTrackingInfoStream(DocumentReference userRef) {
    return db
        .collection(FirestorePath.URL_TRACKING)
        .where(FirestorePath.USERS, arrayContains: userRef)
        .snapshots();
  }

  List<TrackingInfo> _getTrackingInfoFrom(QuerySnapshot query) {
    return query.documents
        .map((document) => TrackingInfo.fromDocumentSnapshot(document))
        .toList();
  }

  @override
  Observable<List<TrackingInfo>> getTrackingInfo({String uid}) {
    return Observable.fromFuture(getUserRef(uid: uid))
        .flatMap((userRef) => Observable(_getTrackingInfoStream(userRef)))
        .map(_getTrackingInfoFrom)
        .doOnListen(() => print("Firestore: getTrackingInfo"));
  }

  @override
  Observable<List<TrackingHistory>> getTrackingHistoryByInfo(
    TrackingInfo info,
    DocumentSnapshot lastDoc,
  ) {
    var getHistoryFrom = (QuerySnapshot query) => query.documents
        .map((document) => TrackingHistory.fromDocumentSnapshot(document))
        .toList();

    //DateTime now = DateTime.now();

    var qurey = info.history
        // .where("at", isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day, 0))
        // .where("at", isLessThanOrEqualTo: DateTime(now.year, now.month, now.day, 24, 59))
        .orderBy("at", descending: true);

    if (lastDoc != null) {
      qurey = qurey.startAfterDocument(lastDoc);
    }

    var historyStream = qurey.limit(20).snapshots();

    return Observable(historyStream)
        .map(getHistoryFrom)
        .doOnListen(() => print("Firestore: getTrackingHistoryByInfo"));
  }

  @override
  Observable<bool> createAnonymousUser() {
    return Observable.fromFuture(_createAnonymousUser())
        .doOnListen(() => print("Firestore: createAnonymousUser"));
  }

  Future<bool> _createAnonymousUser() async {
    var deviceToken = await FcmPlugin.getDeviceToken();
    var deviceId = await Util.getDeviceId();

    var data = {'loginType': 0};

    var deviceSignedIn = {
      'os': Platform.operatingSystem,
      'deviceToken': deviceToken,
      'deviceId': deviceId,
    };

    var newUserRef = db.collection(FirestorePath.COLLECTION_USERS).document();

    var querySnapshot = await getQUserByDeviceId(deviceId).getDocuments();
    if (querySnapshot.documents.isNotEmpty) {
      return false;
    }

    await newUserRef.setData(data);
    await newUserRef
        .collection(FirestorePath.DEVICE_SIGNED_IN)
        .document()
        .setData(deviceSignedIn);

    return true;
  }

  @override
  Observable<void> addNewUrlTrackingForUser(String url, {String uid}) {
    return Observable.fromFuture(_addNewUrlTrackingForUser(url, uid: uid))
        .doOnListen(() => print("Firestore: addNewUrlTrackingForUser"));
  }

  Future<void> _addNewUrlTrackingForUser(String url, {String uid}) async {
    var data = {
      'tracking': FieldValue.arrayUnion([url])
    };
    var docRef = await getUserRef(uid: uid);

    return await docRef.updateData(data);
  }

  @override
  Observable<void> deleteUrlTrackingForUser(String url, {String uid}) {
    return Observable.fromFuture(_deleteUrlTrackingForUser(url, uid: uid))
        .doOnListen(() => print("Firestore: deleteUrlTrackingForUser"));
  }

  Future<void> _deleteUrlTrackingForUser(String url, {String uid}) async {
    DocumentReference userRef = await getUserRef(uid: uid);

    var data = {
      'tracking': FieldValue.arrayRemove([url])
    };

    return await userRef.updateData(data);
  }

  @override
  Observable<User> signedIn(String uid) {
    return Observable.fromFuture(_signedIn(uid))
        .doOnListen(() => print("Firestore: linkAndGetUser"));
  }

  Future<User> _signedIn(String uid) async {
    var userRef = await getUserRefByUid(uid);
    var deviceUserRef = await getUserRefByDeviceId();
    var deviceUserDoc = await deviceUserRef.get();

    var deviceUser = User.fromDocumentSnapshot(deviceUserDoc);

    if (userRef != null) {
      await userRef.updateData({'loginStatus': 1, 'loginType': 1});

      DocumentSnapshot doc = await userRef.get();
      User user = User.fromDocumentSnapshot(doc);

      await _mergeSignedInDevice(deviceUser, user);

      return user;
    }

    return _linkAndGetUser(uid);
  }

  Future<void> _mergeSignedInDevice(User from, User to) async {
    var isSignedInOnThisDevice = false;
    var fromDeviceDoc = (await from.deviceSignedIn.getDocuments()).documents[0];
    var fromDevice = DeviceSignedIn.fromDocumentSnapshot(fromDeviceDoc);

    var toDeviceDocs = await to.deviceSignedIn.getDocuments();

    for (final toDeviceDoc in toDeviceDocs.documents) {
      var toDevice = DeviceSignedIn.fromDocumentSnapshot(toDeviceDoc);

      if (toDevice.deviceToken == fromDevice.deviceToken) {
        isSignedInOnThisDevice = true;
        break;
      }
    }

    if (!isSignedInOnThisDevice) {
      var deviceSignedIn = {
        'os': Platform.operatingSystem,
        'deviceToken': fromDevice.deviceToken,
        'deviceId': fromDevice.deviceId,
      };

      var mergedAt = {'mergedAt': FieldValue.serverTimestamp()};

      await to.deviceSignedIn.add(deviceSignedIn);
      await from.firebaseRef.updateData(mergedAt);
    }

    return;
  }

  Future<User> _linkAndGetUser(String uid) async {
    var docRef = await getUserRef();
    DocumentSnapshot doc = await docRef.get();
    User user = User.fromDocumentSnapshot(doc);

    user.uid = uid;
    user.loginStatus = 1;
    await docRef.updateData({'uid': uid, 'loginStatus': 1, 'loginType': 1});

    return user;
  }

  @override
  Future<User> getUserByUid(String uid) {
    return Observable.fromFuture(_getUserByUid(uid))
        .doOnListen(() => print("Firestore: getUserByUid"))
        .first;
  }

  Future<User> _getUserByUid(String uid) async {
    var docRef = await getUserRefByUid(uid);
    var doc = await docRef.get();

    return User.fromDocumentSnapshot(doc);
  }

  @override
  Observable<void> signOut(String uid) {
    return Observable.fromFuture(_signOut(uid))
        .doOnListen(() => print("Firestore: signOut"));
  }

  Future<void> _signOut(String uid) async {
    var data = {'loginStatus': 0};
    var docRef = await getUserRef(uid: uid);

    await docRef.updateData(data);

    await auth.signOut();

    return;
  }
}
