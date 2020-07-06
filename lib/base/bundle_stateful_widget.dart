import 'package:flutter/material.dart';

abstract class BundleStatefulWidget extends StatefulWidget {
  final MapBundle bundle;

  BundleStatefulWidget({Key key, this.bundle}) : super(key: key);
}

class MapBundle extends Bundle<Map<String, dynamic>> {
  const MapBundle({@required Map<String, dynamic> bundle})
      : super(bundle: bundle);

  @override
  T getData<T>(String key) {
    if (bundle == null || !bundle.containsKey(key)) {
      return null;
    }

    return bundle[key];
  }
}

abstract class Bundle<BundleType> {
  final BundleType bundle;

  const Bundle({this.bundle});

  T getData<T>(String key);
}
