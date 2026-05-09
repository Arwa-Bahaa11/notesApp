import 'package:notes/core/utils/local_storage.dart';
import 'package:notes/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:notes/features/auth/domain/entities/user.dart';
import 'package:notes/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final userModel = await remoteDatasource.register(
      name: name,
      email: email,
      password: password,
    );
    await LocalStorage.saveToken(userModel.token);
    await LocalStorage.saveUser(name: userModel.name, email: userModel.email);
    return userModel;
  }

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final userModel = await remoteDatasource.login(
      email: email,
      password: password,
    );
    await LocalStorage.saveToken(userModel.token);
    await LocalStorage.saveUser(name: userModel.name, email: userModel.email);
    return userModel;
  }
}
