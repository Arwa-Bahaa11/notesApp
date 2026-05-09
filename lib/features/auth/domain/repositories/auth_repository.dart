import 'package:notes/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> register({
    required String name,
    required String email,
    required String password,
  });

  Future<User> login({
    required String email,
    required String password,
  });
}
