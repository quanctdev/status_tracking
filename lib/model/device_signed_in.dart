import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceSignedIn {
  String deviceToken;
  String os;
  String deviceId;
  Timestamp lastTimeSendAlarm;

  DeviceSignedIn.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    this.deviceToken = snapshot.data["deviceToken"];
    this.os = snapshot.data["os"];
    this.deviceId = snapshot.data["deviceId"];
    this.lastTimeSendAlarm = snapshot.data["lastTimeSendAlarm"];
  }
}
