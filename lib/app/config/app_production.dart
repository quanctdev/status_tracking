import 'env.dart';

void main() => Production();

class Production extends Env {
  EnvironmentType environmentType = EnvironmentType.PRODUCTION;

  @override
  String get appName => 'Status Tracking';

  @override
  bool get useHotReloadForRx => true;

  Production();
}
