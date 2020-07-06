import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:status/model/firebase_model.dart';

class User implements FirebaseModel {
  String uid;
  int loginType;
  int loginStatus;

  List<String> trackings;

  CollectionReference deviceSignedIn;

  User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    this.firebaseRef = snapshot.reference;
    this.uid = snapshot.data["uid"];
    this.loginStatus = snapshot.data["loginStatus"];
    this.trackings = (snapshot.data["tracking"] ?? []).cast<String>();
    this.deviceSignedIn = snapshot.reference.collection("deviceSignedIn");
  }

  @override
  DocumentReference firebaseRef;
}
