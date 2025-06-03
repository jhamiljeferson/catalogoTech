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
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      final expiration = prefs.getString('token_expiration');
      if (expiration != null) {
        _tokenExpirationDate = DateTime.parse(expiration);
      }

      if (_token != null &&
          _tokenExpirationDate != null &&
          _tokenExpirationDate!.isBefore(DateTime.now())) {
        await logout();
      }

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar token: $e');
    }
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
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.8:9191/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        final expirationDate = DateTime.now().add(const Duration(hours: 3));
        _tokenExpirationDate = expirationDate;
        await saveToken(_token!, expirationDate);
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      print('Erro ao fazer login: $e');
      return false;
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    int cargoId,
    String role,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.8:9191/auth/register'),
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
    } catch (e) {
      print('Erro ao registrar: $e');
      return false;
    }
  }
}
