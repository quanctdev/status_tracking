import 'package:flutter/services.dart';

class FcmPlugin {
  static const _channel = const MethodChannel("flutter.app/plugin");

  static Future<String> getDeviceToken() async {
    return _channel.invokeMethod('getDeviceToken');
  }
}
