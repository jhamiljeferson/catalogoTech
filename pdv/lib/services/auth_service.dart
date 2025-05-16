import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  String? _token;
  DateTime? _tokenExpirationDate;

  String? get token => _token;

  Future<void> saveToken(String token, DateTime expirationDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('token_expiration', expirationDate.toIso8601String());
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    final expiration = prefs.getString('token_expiration');
    if (expiration != null) {
      _tokenExpirationDate = DateTime.parse(expiration);
    }

    // Verifica se o token expirou
    if (_token != null &&
        _tokenExpirationDate != null &&
        _tokenExpirationDate!.isBefore(DateTime.now())) {
      _token = null; // Limpa o token se ele expirou
      _tokenExpirationDate = null;
      await logout();
    }

    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _tokenExpirationDate = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('token_expiration');
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:9191/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      final expirationDate = DateTime.now().add(
        Duration(hours: 3),
      ); // 3 horas de duração do token
      _tokenExpirationDate = expirationDate;
      await saveToken(_token!, expirationDate);
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    int cargoId,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse('http://localhost:9191/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': name,
        'email': email,
        'senha': password,
        'cargoId': cargoId,
        'role': role,
      }),
    );

    return response.statusCode == 201;
  }
}
