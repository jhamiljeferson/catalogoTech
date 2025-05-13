import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class AuthService with ChangeNotifier {
  String? _token;
  List<Task> _tasks = [];

  String? get token => _token;
  List<Task> get tasks => _tasks;

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _tasks = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
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
      await saveToken(_token!);
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
