import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdv/models/PaginatedResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/categoria_model.dart';

class CategoriaService {
  static const String baseUrl = 'http://localhost:9191/categorias';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<PaginatedResponse<Categoria>> listarCategoriasPaginado(
    int page,
  ) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl?page=$page'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PaginatedResponse<Categoria>.fromJson(
        json,
        (item) => Categoria.fromJson(item),
      );
    } else {
      throw Exception('Erro ao carregar categorias');
    }
  }

  Future<List<Categoria>> listarCategorias() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['content']; // <-- AQUI
      return data.map((json) => Categoria.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar categorias');
    }
  }

  Future<void> cadastrarCategoria(Categoria categoria) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(categoria.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao cadastrar categoria');
    }
  }

  Future<void> atualizarCategoria(Categoria categoria) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/${categoria.id}'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(categoria.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar categoria');
    }
  }

  Future<void> deletarCategoria(int id) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Erro ao deletar categoria');
    }
  }
}
