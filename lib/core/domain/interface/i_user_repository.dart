import 'package:dartz/dartz.dart';
import 'package:vintage_jokes/core/domain/model/user.dart';

abstract class IUserRepository {
  Future<Option<User>> get user;
}
