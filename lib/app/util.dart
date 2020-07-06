import 'dart:io';

import 'package:device_info/device_info.dart';

class Util {
  static String getError(error) {
    String sError;
    if (error is Exception) {
      sError = error.toString();
    }
    //  else if (error is TypeError) {
    //   sError = error.message;
    // }
    else if (error is AssertionError) {
      sError = error.toString();
    } else if (error is String) {
      sError = error;
    } else {
      sError = error.toString();
    }

    return sError;
  }

  static Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    }

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return '${androidDeviceInfo.model}-${androidDeviceInfo.androidId}';
    }

    throw Exception("Cannot create device id");
  }
}
