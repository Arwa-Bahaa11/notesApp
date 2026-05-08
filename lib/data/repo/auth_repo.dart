import 'package:dio/dio.dart';
import 'package:notes/core/networks/dio_client.dart';
import '../models/user_model.dart';
import '../../core/constants/api_constants.dart';

class AuthRepository {
  final Dio _dio = ApiClient.instance;

  // دالة التسجيل
  Future<UserModel> register({required String name, required String email, required String password}) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {'name': name, 'email': email, 'password': password},
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "خطأ في عملية التسجيل";
    }
  }

  // دالة تسجيل الدخول
  Future<UserModel> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "البريد أو كلمة المرور خاطئة";
    }
  }
}