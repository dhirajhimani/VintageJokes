import 'package:dartz/dartz.dart';
import 'package:vintage_jokes/core/domain/model/failures.dart';
import 'package:vintage_jokes/core/domain/model/value_objects.dart';

abstract class IAuthRepository {
  Future<Either<Failure, Unit>> login(EmailAddress email, Password password);

  Future<Either<Failure, Unit>> logout();
}
