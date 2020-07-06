import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:status/base/extension/extension.dart';

class TrackingHistory {
  Timestamp _at;
  int _statusCode;
  String statusMessage;
  String date;

  DocumentSnapshot snapshot;

  TrackingHistory.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    this.snapshot = snapshot;
    this._at = snapshot.data["at"];
    this._statusCode = snapshot.data["statusCode"] ?? 0;
    this.statusMessage = snapshot.data["statusMessage"] ?? "";

    this.date = _at?.toStringWith("dd MMM") ?? "";
  }

  String get at => _at?.toStringWith("HH:mm") ?? "";

  String get statusCode => '# $_statusCode';

  bool get isError => _statusCode != 200;
}
