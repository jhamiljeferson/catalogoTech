import '../config/api_config.dart';
import '../models/cor_model.dart';
import 'base_service.dart';

class CorService extends BaseService {
  static const String endpoint = ApiConfig.coresEndpoint;

  Future<List<Cor>> listarCores() async {
    await validateToken();

    final response = await apiClient.get<Map<String, dynamic>>(
      endpoint,
      fromJson: (json) => json,
    );

    final List<dynamic> content = response['content'] as List;
    return content
        .map((item) => Cor.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Cor> buscarPorId(int id) async {
    await validateToken();

    return await apiClient.get(
      '$endpoint/$id',
      fromJson: (json) => Cor.fromJson(json),
    );
  }

  Future<void> cadastrar(Cor cor) async {
    await validateToken();
    await apiClient.post(endpoint, cor.toJson());
  }

  Future<void> atualizar(Cor cor) async {
    await validateToken();
    await apiClient.put('$endpoint/${cor.id}', cor.toJson());
  }

  Future<void> deletar(int id) async {
    await validateToken();
    await apiClient.delete('$endpoint/$id');
  }
}
