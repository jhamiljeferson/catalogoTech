import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final http.Client _client = http.Client();

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Bearer $token' : '',
    };
  }

  Future<T> get<T>(
    String path, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _client
          .get(Uri.parse(path), headers: await _getHeaders())
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final json = jsonDecode(decodedBody);

        if (fromJson != null) {
          return fromJson(json);
        }
        return json as T;
      }

      throw Exception('Erro na requisição: ${response.statusCode}');
    } catch (e) {
      throw Exception('Erro ao realizar requisição: $e');
    }
  }

  Future<T> post<T>(
    String path,
    dynamic data, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(path),
            headers: await _getHeaders(),
            body: jsonEncode(data),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.body.isEmpty) {
          return null as T;
        }

        final json = jsonDecode(response.body);
        if (fromJson != null) {
          return fromJson(json);
        }
        return json as T;
      }

      throw Exception('Erro na requisição: ${response.statusCode}');
    } catch (e) {
      throw Exception('Erro ao realizar requisição: $e');
    }
  }

  Future<T> put<T>(
    String path,
    dynamic data, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _client
          .put(
            Uri.parse(path),
            headers: await _getHeaders(),
            body: jsonEncode(data),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return null as T;
        }

        final json = jsonDecode(response.body);
        if (fromJson != null) {
          return fromJson(json);
        }
        return json as T;
      }

      throw Exception('Erro na requisição: ${response.statusCode}');
    } catch (e) {
      throw Exception('Erro ao realizar requisição: $e');
    }
  }

  Future<void> delete(String path) async {
    try {
      final response = await _client
          .delete(Uri.parse(path), headers: await _getHeaders())
          .timeout(ApiConfig.timeout);

      if (response.statusCode != 204) {
        throw Exception('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao realizar requisição: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
