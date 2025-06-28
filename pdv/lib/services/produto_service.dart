import '../config/api_config.dart';
import '../models/PaginatedResponse.dart';
import '../models/produto/produto_listagem_dto.dart';
import '../models/produto/produto_cadastro_dto.dart';
import 'base_service.dart';

class ProdutoService extends BaseService {
  Future<PaginatedResponse<ProdutoListagemDto>> listarPaginado(int page) async {
    await validateToken();
    return await apiClient.get(
      '${ApiConfig.produtosEndpoint}?page=$page',
      fromJson:
          (json) => PaginatedResponse<ProdutoListagemDto>.fromJson(
            json,
            (item) => ProdutoListagemDto.fromJson(item),
          ),
    );
  }

  Future<void> deletar(int id) async {
    await validateToken();
    await apiClient.delete('${ApiConfig.produtosEndpoint}/$id');
  }

  Future<void> cadastrarProduto(ProdutoCadastroDto dto) async {
    await validateToken();
    await apiClient.post(
      '${ApiConfig.produtosEndpoint}/variacao',
      dto.toJson(),
    );
  }
}
