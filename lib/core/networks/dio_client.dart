import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiClient {
  // 1. إنشاء نسخة Singleton من Dio لضمان استهلاك أقل للذاكرة
  static final Dio _dio = Dio(
    BaseOptions(
      // العنوان الرئيسي للسيرفر
      baseUrl: ApiConstants.baseUrl,
      
      // وقت الانتظار قبل ما الطلب يفشل (15 ثانية)
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      
      // إعدادات الـ Headers الأساسية
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      
      // دي أهم حتة: بتخلي الـ Dio يرمي Exception لو الكود مش 200 أو 201
      // وده بيخلي الـ Catch اللي في الـ Repository يشتغل صح
      validateStatus: (status) => status != null && status >= 200 && status < 300,
    ),
  )..interceptors.add(_LoggingInterceptor()); // إضافة الـ Logger لمراقبة الطلبات

  // Getter للوصول لنسخة الـ Dio من أي مكان
  static Dio get instance => _dio;
}

// 2. كلاس الـ Interceptor لمراقبة الـ Requests والـ Responses في الـ Console
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🔵 REQUEST [${options.method}] => PATH: ${options.path}');
    print('📦 DATA: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('🟢 RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('📨 DATA: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('🔴 ERROR [${err.response?.statusCode}] => MESSAGE: ${err.message}');
    print('📋 ERROR DATA: ${err.response?.data}');
    super.onError(err, handler);
  }
}