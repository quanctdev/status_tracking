import 'package:logging/logging.dart';

import 'env.dart';

void main() => Development();

class Development extends Env {
  EnvironmentType environmentType = EnvironmentType.DEVELOPMENT;

  @override
  String get appName => 'Status Tracking Dev';

  @override
  bool get useHotReloadForRx => false;

  Development() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.error}: ${record.stackTrace}');
    });
  }
}
