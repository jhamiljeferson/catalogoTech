import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdv/models/fornecedor/fornecedor_detalhamento_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/PaginatedResponse.dart';
import '../models/fornecedor/fornecedor_cadastro_dto.dart';
import '../models/fornecedor/fornecedor_listagem_dto.dart';
import '../models/fornecedor/fornecedor_atualizacao_dto.dart';

class FornecedorService {
  static const String baseUrl = 'http://localhost:9191/fornecedores';

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

  // Método para listar fornecedores paginados
  Future<PaginatedResponse<FornecedorListagemDto>> listarPaginado(
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
      return PaginatedResponse<FornecedorListagemDto>.fromJson(
        json,
        (item) => FornecedorListagemDto.fromJson(item),
      );
    } else {
      throw Exception('Erro ao carregar fornecedores');
    }
  }

  // Método para cadastrar fornecedor
  Future<void> cadastrar(FornecedorCadastroDto dto) async {
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
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao cadastrar fornecedor');
    }
  }

  // Método para atualizar fornecedor
  Future<void> atualizar(int id, FornecedorAtualizacaoDto dto) async {
    final token = await _getToken();

    // Verifica se o token é válido
    if (token == null || !await _isTokenValid()) {
      throw Exception('Token expirado ou não encontrado');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar fornecedor');
    }
  }

  // Método para deletar fornecedor
  Future<void> deletar(int id) async {
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
      throw Exception('Erro ao deletar fornecedor');
    }
  }

  // Método para buscar fornecedor por ID
  Future<FornecedorDetalhamentoDto> buscarPorId(int id) async {
    final token = await _getToken();

    // Verifica se o token é válido
    if (token == null || !await _isTokenValid()) {
      throw Exception('Token expirado ou não encontrado');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return FornecedorDetalhamentoDto.fromJson(data);
    } else {
      throw Exception('Erro ao buscar fornecedor');
    }
  }
}
