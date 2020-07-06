import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:status/app/util.dart';
import 'package:status/network/firestore_path.dart';

class FirebaseManager {
  Firestore get db => Firestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;

  Future<DocumentReference> getUserRef({String uid}) =>
      uid == null ? getUserRefByDeviceId() : getUserRefByUid(uid);

  Future<DocumentReference> getUserRefByDeviceId() async {
    var deviceId = await Util.getDeviceId();
    var querySnapshot = await getQUserByDeviceId(deviceId).getDocuments();

    if (querySnapshot.documents.isNotEmpty) {
      String path = querySnapshot.documents[0].reference.path;
      var uPath = path.split("/");
      var uDoc = await db.collection(uPath[0]).document(uPath[1]).get();
      return uDoc.reference;
    }

    throw Exception("User not found");
  }

  Future<DocumentReference> getUserRefByUid(String uid) async {
    var querySnapshot = await getQUserByUid(uid).getDocuments();

    if (querySnapshot.documents.isNotEmpty) {
      return querySnapshot.documents[0].reference;
    }

    return null;
  }

  Query getQUserByDeviceId(String deviceId) {
    return db
        .collectionGroup(FirestorePath.DEVICE_SIGNED_IN)
        .where(FirestorePath.DEVICE_ID, isEqualTo: deviceId);
  }

  Query getQUserByUid(String uid) {
    return db
        .collection(FirestorePath.COLLECTION_USERS)
        .where(FirestorePath.UID, isEqualTo: uid);
  }
}
