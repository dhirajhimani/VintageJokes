import 'package:vintage_jokes/app/utils/injection.dart';

class DependencyGlobal {
  static bool get isMockLogin => getIt<bool>(instanceName: 'isMockLogin');
}
