import 'produto_variacao_dto.dart';

class ProdutoCadastroDto {
  final String nome;
  final String descricao;
  final String codigo;
  final int categoriaId;
  final int fornecedorId;
  final String foto;
  final List<String> cores;
  final List<String> tamanhos;
  final List<ProdutoVariacaoDto> variacoes;

  ProdutoCadastroDto({
    required this.nome,
    required this.descricao,
    required this.codigo,
    required this.categoriaId,
    required this.fornecedorId,
    required this.foto,
    required this.cores,
    required this.tamanhos,
    required this.variacoes,
  });

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descricao': descricao,
    'codigo': codigo,
    'categoriaId': categoriaId,
    'fornecedorId': fornecedorId,
    'foto': foto,
    'cores': cores,
    'tamanhos': tamanhos,
    'variacoes': variacoes.map((v) => v.toJson()).toList(),
  };
}
