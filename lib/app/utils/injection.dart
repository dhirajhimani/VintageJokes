import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:vintage_jokes/app/constants/enum.dart';
import 'package:vintage_jokes/app/utils/injection.config.dart';

// ignore_for_file: prefer-static-class
final GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
Future<void> configureDependencies(Env env) =>
    getIt.init(environment: env.value);
