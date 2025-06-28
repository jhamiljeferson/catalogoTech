class ProdutoListagemDto {
  final int id;
  final String nome;
  final String codigo;
  final String categoria;
  final String fornecedor;
  final bool ativo;
  final List<String> cores;
  final List<String> tamanhos;
  final String? imagemUrl;

  ProdutoListagemDto({
    required this.id,
    required this.nome,
    required this.codigo,
    required this.categoria,
    required this.fornecedor,
    required this.ativo,
    required this.cores,
    required this.tamanhos,
    this.imagemUrl,
  });

  factory ProdutoListagemDto.fromJson(Map<String, dynamic> json) {
    return ProdutoListagemDto(
      id: json['id'],
      nome: json['nome'],
      codigo: json['codigo'],
      categoria: json['categoria'],
      fornecedor: json['fornecedor'],
      ativo: json['ativo'],
      cores: List<String>.from(json['cores']),
      tamanhos: List<String>.from(json['tamanhos']),
      imagemUrl: json['imagemUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'codigo': codigo,
      'categoria': categoria,
      'fornecedor': fornecedor,
      'ativo': ativo,
      'cores': cores,
      'tamanhos': tamanhos,
      'imagemUrl': imagemUrl,
    };
  }
}
