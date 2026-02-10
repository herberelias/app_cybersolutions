import 'package:dio/dio.dart';

class DioClient {
  static Dio createDio({
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 15),
    int maxRetries = 3,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Aquí podríamos agregar token si lo tuviéramos en memoria
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Lógica básica de reintento si es necesario
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
