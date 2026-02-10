import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dio_client.dart';

class AuthService {
  // CONFIGURACIÓN DE URL DEL SERVIDOR
  final Dio _dio = DioClient.createDio(
    baseUrl: 'http://64.23.132.230:3002/api', // Puerto 3002 según tu .env
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  );

  final _storage = const FlutterSecureStorage();

  // LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        // Guardar TOKEN seguro
        await _storage.write(key: 'jwt_token', value: token);
        return {'success': true, 'user': response.data['user']};
      }
      return {'success': false, 'message': 'Credenciales inválidas'};
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  // REGISTER
  Future<Map<String, dynamic>> register(
    String nombre,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {'nombre': nombre, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Registro exitoso'};
      }
      return {'success': false, 'message': 'Error al registrar'};
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado: $e'};
    }
  }

  // BIOMETRIC HELPERS
  Future<void> enableBiometricLogin(String email, String password) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);
  }

  Future<void> disableBiometricLogin() async {
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'password');
  }

  Future<Map<String, dynamic>> loginWithStoredCredentials() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');

    if (email != null && password != null) {
      return login(email, password);
    }
    return {'success': false, 'message': 'No hay credenciales guardadas'};
  }

  Future<bool> hasStoredCredentials() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');
    return email != null && password != null;
  }

  // TOKEN MANAGEMENT
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<Map<String, dynamic>> validateToken() async {
    try {
      final token = await getToken();
      if (token == null) return {'success': false, 'message': 'No token'};

      final response = await _dio.get(
        '/auth/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'user': response.data['user']};
      }
      return {'success': false, 'message': 'Token inválido'};
    } catch (e) {
      return {'success': false, 'message': 'Sesión expirada'};
    }
  }

  // ERROR HANDLING
  Map<String, dynamic> _handleDioError(DioException e) {
    if (e.response != null) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Error de servidor',
      };
    }
    String errorMsg = 'Error de conexión';
    if (e.type == DioExceptionType.connectionTimeout) {
      errorMsg = 'Tiempo de espera agotado. Verifica tu internet.';
    } else if (e.type == DioExceptionType.connectionError) {
      errorMsg = 'Sin conexión a internet.';
    }
    return {'success': false, 'message': errorMsg};
  }
}
