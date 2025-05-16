import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/PaginatedResponse.dart';
import '../models/categoria_model.dart';

class CategoriaService {
  static const String baseUrl = 'http://localhost:9191/categorias';

  // Verifica o token armazenado
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Verifica a validade do token
  Future<DateTime?> _getTokenExpirationDate() async {
    final prefs = await SharedPreferences.getInstance();
    final expiration = prefs.getString('token_expiration');
    if (expiration != null) {
      return DateTime.parse(expiration);
    }
    return null;
  }

  // Verifica se o token é válido
  Future<bool> _isTokenValid() async {
    final expirationDate = await _getTokenExpirationDate();
    if (expirationDate == null || expirationDate.isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }

  // Método para listar categorias paginadas
  Future<PaginatedResponse<Categoria>> listarCategoriasPaginado(
    int page,
  ) async {
    final token = await _getToken();

    // Verifica se o token é válido
    if (token == null || !await _isTokenValid()) {
      throw Exception('Token expirado ou não encontrado');
    }

    final response = await http.get(
      Uri.parse('$baseUrl?page=$page'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final json = jsonDecode(decodedBody);

      return PaginatedResponse<Categoria>.fromJson(
        json,
        (item) => Categoria.fromJson(item),
      );
    } else {
      throw Exception('Erro ao carregar categorias');
    }
  }

  // Método para cadastrar categoria
  Future<void> cadastrarCategoria(Categoria categoria) async {
    final token = await _getToken();

    // Verifica se o token é válido
    if (token == null || !await _isTokenValid()) {
      throw Exception('Token expirado ou não encontrado');
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(categoria.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao cadastrar categoria');
    }
  }

  // Método para atualizar categoria
  Future<void> atualizarCategoria(Categoria categoria) async {
    final token = await _getToken();

    // Verifica se o token é válido
    if (token == null || !await _isTokenValid()) {
      throw Exception('Token expirado ou não encontrado');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/${categoria.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(categoria.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar categoria');
    }
  }

  // Método para deletar categoria
  Future<void> deletarCategoria(int id) async {
    final token = await _getToken();

    // Verifica se o token é válido
    if (token == null || !await _isTokenValid()) {
      throw Exception('Token expirado ou não encontrado');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Erro ao deletar categoria');
    }
  }
}
