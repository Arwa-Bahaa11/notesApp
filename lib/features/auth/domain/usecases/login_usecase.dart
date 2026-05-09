import 'package:notes/features/auth/domain/entities/user.dart';
import 'package:notes/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  Future<User> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
}
