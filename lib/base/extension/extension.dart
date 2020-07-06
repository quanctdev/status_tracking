export 'rx_extension.dart';
export 'string_extension.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:status/initialize_i18n/app_localizations.dart';

extension ObjectExt on Object {
  T as<T>() => this is T ? this : null;

  bool instanceOf<T>() => this is T ? true : false;
}

extension NumExt on num {}

extension BuildContextExt on BuildContext {
  String string(String key) => AppLocalizations.of(this)?.text(key) ?? "Error Localizations";
}

extension Wiget on Widget {
  Widget visible(bool isVisible) => isVisible ? this : Container();
}

extension TimestampExt on Timestamp {
  String toStringWith(String pattern) {
    DateTime date = this.toDate();

    DateFormat dateFormat = DateFormat(pattern);
    return dateFormat.format(date);
  }
}
