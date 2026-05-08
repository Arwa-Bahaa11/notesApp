import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../utils/local_storage.dart';

class ApiClient {
  // جعل الـ Dio متغير خاص
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      // السماح بقراءة الردود حتى لو كانت حالات خطأ (مثل 400 أو 401)
      // لكي نتمكن من عرض رسالة الخطأ القادمة من السيرفر
      validateStatus: (status) => status != null && status < 500,
    ),
  )..interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
    ]);

  static Dio get instance => _dio;
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String? token = LocalStorage.getToken();

    // تأكدي أن الـ Endpoints الخاصة بالـ Auth لا تأخذ توكن قديم أو فارغ
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options); // استخدام handler.next أفضل للمتابعة
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🚀 REQUEST [${options.method}] => PATH: ${options.path}');
    // طباعة البيانات المرسلة للتأكد من أنها ليست null
    print('Body Data: ${options.data}');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '✅ RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}');
    // طباعة الرد القادم للتأكد من وصول البيانات
    print('Response Data: ${response.data}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
        '❌ ERROR [${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('ERROR MESSAGE: ${err.message}');
    print('ERROR DATA: ${err.response?.data}');
    return handler.next(err);
  }
}
