import '../config/api_config.dart';
import '../models/PaginatedResponse.dart';
import '../models/categoria_model.dart';
import 'base_service.dart';

class CategoriaService extends BaseService {
  Future<PaginatedResponse<Categoria>> listarCategoriasPaginado(
    int page,
  ) async {
    await validateToken();

    return await apiClient.get(
      '${ApiConfig.categoriasEndpoint}?page=$page',
      fromJson:
          (json) => PaginatedResponse<Categoria>.fromJson(
            json,
            (item) => Categoria.fromJson(item),
          ),
    );
  }

  Future<void> cadastrarCategoria(Categoria categoria) async {
    await validateToken();

    await apiClient.post(ApiConfig.categoriasEndpoint, categoria.toJson());
  }

  Future<void> atualizarCategoria(Categoria categoria) async {
    await validateToken();

    await apiClient.put(
      '${ApiConfig.categoriasEndpoint}/${categoria.id}',
      categoria.toJson(),
    );
  }

  Future<void> deletarCategoria(int id) async {
    await validateToken();

    await apiClient.delete('${ApiConfig.categoriasEndpoint}/$id');
  }
}
