import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vintage_jokes/app/utils/injection.dart';
import 'package:vintage_jokes/core/data/service/user_service.dart';
import 'package:vintage_jokes/features/auth/data/service/auth_service.dart';
import 'package:vintage_jokes/features/home/data/service/post_service.dart';

@module
abstract class ServiceModule {
  @Named('isMockLogin')
  bool get isMockLogin => const String.fromEnvironment('MOCK_LOGIN').isNotEmpty;

  //Lo   cal Storage Service
  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage();

  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  //API Service
  @lazySingleton
  AuthService get authService =>
      getIt<ChopperClient>().getService<AuthService>();

  @lazySingleton
  UserService get userService =>
      getIt<ChopperClient>().getService<UserService>();

  @lazySingleton
  PostService get postService =>
      getIt<ChopperClient>().getService<PostService>();
}
