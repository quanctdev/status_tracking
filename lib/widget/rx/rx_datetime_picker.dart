import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:status/base/extension/extension.dart';

class RxDatetimePicker {
  final BuildContext _context;

  final DateTime _initialDate;

  final DateTime _firstDate;

  final DateTime _lastDate;

  String _dateFormatPattern = "yyyy-MM-dd";

  RxDatetimePicker(
      this._context, this._initialDate, this._firstDate, this._lastDate);

  RxDatetimePicker buildDateFormatPattern(String newPattern) {
    _dateFormatPattern = newPattern;
    return this;
  }

  Observable<String> get rx => Observable.fromFuture(showDatePicker(
        context: _context,
        initialDate: _initialDate,
        firstDate: _firstDate,
        lastDate: _lastDate,
        builder: (BuildContext context, Widget child) {
          return child;
        },
      ))
      .isNotNull()
      .map((dateTime) => DateFormat(_dateFormatPattern).format(dateTime));
}
