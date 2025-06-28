import '../config/api_config.dart';
import '../models/tamanho_model.dart';
import 'base_service.dart';

class TamanhoService extends BaseService {
  static const String endpoint = ApiConfig.tamanhosEndpoint;

  Future<List<Tamanho>> listarTamanhos() async {
    await validateToken();

    final response = await apiClient.get<Map<String, dynamic>>(
      endpoint,
      fromJson: (json) => json,
    );

    final List<dynamic> content = response['content'] as List;
    return content
        .map((item) => Tamanho.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Tamanho> buscarPorId(int id) async {
    await validateToken();

    return await apiClient.get(
      '$endpoint/$id',
      fromJson: (json) => Tamanho.fromJson(json),
    );
  }

  Future<void> cadastrar(Tamanho tamanho) async {
    await validateToken();
    await apiClient.post(endpoint, tamanho.toJson());
  }

  Future<void> atualizar(Tamanho tamanho) async {
    await validateToken();
    await apiClient.put('$endpoint/${tamanho.id}', tamanho.toJson());
  }

  Future<void> deletar(int id) async {
    await validateToken();
    await apiClient.delete('$endpoint/$id');
  }
}
