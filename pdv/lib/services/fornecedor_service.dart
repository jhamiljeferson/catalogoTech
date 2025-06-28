import '../config/api_config.dart';
import '../models/PaginatedResponse.dart';
import '../models/fornecedor/fornecedor_cadastro_dto.dart';
import '../models/fornecedor/fornecedor_listagem_dto.dart';
import '../models/fornecedor/fornecedor_atualizacao_dto.dart';
import '../models/fornecedor/fornecedor_detalhamento_dto.dart';
import 'base_service.dart';

class FornecedorService extends BaseService {
  Future<PaginatedResponse<FornecedorListagemDto>> listarPaginado(
    int page,
  ) async {
    await validateToken();
    return await apiClient.get(
      '${ApiConfig.fornecedoresEndpoint}?page=$page',
      fromJson:
          (json) => PaginatedResponse<FornecedorListagemDto>.fromJson(
            json,
            (item) => FornecedorListagemDto.fromJson(item),
          ),
    );
  }

  Future<void> cadastrar(FornecedorCadastroDto dto) async {
    await validateToken();
    await apiClient.post(ApiConfig.fornecedoresEndpoint, dto.toJson());
  }

  Future<void> atualizar(int id, FornecedorAtualizacaoDto dto) async {
    await validateToken();
    await apiClient.put('${ApiConfig.fornecedoresEndpoint}/$id', dto.toJson());
  }

  Future<void> deletar(int id) async {
    await validateToken();
    await apiClient.delete('${ApiConfig.fornecedoresEndpoint}/$id');
  }

  Future<FornecedorDetalhamentoDto> buscarPorId(int id) async {
    await validateToken();
    return await apiClient.get(
      '${ApiConfig.fornecedoresEndpoint}/$id',
      fromJson: (json) => FornecedorDetalhamentoDto.fromJson(json),
    );
  }
}
