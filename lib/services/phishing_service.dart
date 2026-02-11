import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dio_client.dart';

class PhishingService {
  final Dio _dio = DioClient.createDio(
    baseUrl: 'http://64.23.132.230:3002/api',
  );
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<Map<String, dynamic>> analyzeEmail(String content) async {
    try {
      final token = await _getToken();
      final response = await _dio.post(
        '/phishing/analyze',
        data: {'email_content': content},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Error de conexión',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  Future<Map<String, dynamic>> getHistory() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '/phishing/history',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Error de conexión',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }
}
