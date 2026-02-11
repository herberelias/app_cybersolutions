import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dio_client.dart';

class QuizService {
  final Dio _dio = DioClient.createDio(
    baseUrl: 'http://64.23.132.230:3002/api',
  );
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // OBTENER PREGUNTAS
  Future<Map<String, dynamic>> getQuestions() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '/quiz/questions',
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

  // ENVIAR RESPUESTAS
  Future<Map<String, dynamic>> submitQuiz(
    List<Map<String, dynamic>> answers,
  ) async {
    try {
      final token = await _getToken();
      final response = await _dio.post(
        '/quiz/submit',
        data: {'answers': answers},
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

  // OBTENER HISTORIAL
  Future<Map<String, dynamic>> getHistory() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '/quiz/history',
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
