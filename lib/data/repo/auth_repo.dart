import 'package:dio/dio.dart';
import 'package:notes/core/networks/dio_client.dart';
import 'package:notes/core/utils/local_storage.dart';
import '../models/user_model.dart';
import '../../core/constants/api_constants.dart';

class AuthRepository {
  final Dio _dio = ApiClient.instance;

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {'name': name, 'email': email, 'password': password},
      );
      final user = UserModel.fromJson(response.data);
      await LocalStorage.saveToken(user.token);
      await LocalStorage.saveUser(name: user.name, email: user.email);
      return user;
    } on DioException catch (e) {
      throw e.response?.data['message'] ??
          "Registration failed. Please try again.";
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      final user = UserModel.fromJson(response.data);
      await LocalStorage.saveToken(user.token);
      await LocalStorage.saveUser(name: user.name, email: user.email);
      return user;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Invalid email or password.";
    }
  }
}
