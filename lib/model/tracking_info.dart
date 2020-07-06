import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:status/enums/tracking_status.dart';
import 'package:status/network/firestore_path.dart';
import 'package:status/base/extension/extension.dart';

class TrackingInfo {
  Timestamp lastTimeTracking;
  int statusCode;
  String statusMessage;
  String url;
  List<DocumentReference> usersRef;
  CollectionReference history;

  TrackingInfo.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    this.lastTimeTracking = snapshot.data[FirestorePath.LAST_TIME_TRACKING];
    this.statusCode = snapshot.data[FirestorePath.STATUS_CODE];
    this.statusMessage = snapshot.data[FirestorePath.STATUS_MESSAGE] ?? "";
    this.url = snapshot.data[FirestorePath.URL] ?? "";
    this.usersRef = (snapshot.data["users"] ?? []).cast<DocumentReference>();

    this.history = snapshot.reference.collection("history");
  }

  String get lastTimeTrackingFormated {
    if (lastTimeTracking == null) return "Unknown";

    return lastTimeTracking.toStringWith("dd MMM, yyyy | hh:mm aaa");
  }

  String get code => statusCode == null ? "" : "# $statusCode";

  TrackingStatus get trackingStatus {
    TrackingStatus trackingStatus = TrackingStatus.UNKNOWN;

    if (statusCode == null) {
      trackingStatus = TrackingStatus.UNKNOWN;
    } else if (statusCode == 200) {
      trackingStatus = TrackingStatus.UP;
    } else {
      trackingStatus = TrackingStatus.DOWN;
    }

    return trackingStatus;
  }
}
