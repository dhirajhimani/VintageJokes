import 'dart:developer';

import 'package:chopper/chopper.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:vintage_jokes/app/constants/enum.dart';
import 'package:vintage_jokes/app/utils/dependency_global.dart';
import 'package:vintage_jokes/app/utils/extensions.dart';
import 'package:vintage_jokes/core/data/model/user.dto.dart';
import 'package:vintage_jokes/core/data/service/user_service.dart';
import 'package:vintage_jokes/core/domain/interface/i_user_repository.dart';
import 'package:vintage_jokes/core/domain/model/user.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  UserRepository(
    this._userService,
  );

  final UserService _userService;

  User get mockUser => UserDTO(
    uid: 1,
    email: 'exampe@email.com',
    firstName: 'test',
    lastName: 'test',
    gender: 'Male',
    contactNumber: '123456789',
    birthday: DateTime(2000),
  ).toDomain();

  @override
  Future<Option<User>> get user async {
    try {
      // ignore: literal_only_boolean_expressions
      if (DependencyGlobal.isMockLogin) {
        return some(mockUser);
      }
      final Response<dynamic> response = await _userService.getCurrentUser();

      final StatusCode statusCode = response.statusCode.statusCode;

      if (statusCode.isSuccess && response.body != null) {
        final UserDTO userDTO =
            UserDTO.fromJson(response.body!['data'] as Map<String, dynamic>);

        return _validateUserData(userDTO);
      }

      return none();
    } catch (error) {
      log(error.toString());

      return none();
    }
  }

  Option<User> _validateUserData(UserDTO? userDTO) {
    final User? user = userDTO?.toDomain();

    return user?.failureOption.isNone() ?? false // validate user data
        ? some(user!)
        : none();
  }
}
