import 'package:notes/features/auth/domain/entities/user.dart';
import 'package:notes/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase({required this.repository});

  Future<User> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await repository.register(
        name: name, email: email, password: password);
  }
}
