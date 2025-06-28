class ProdutoVariacaoDto {
  final String cor;
  final String tamanho;
  final int quantidade;
  final double preco;
  final double precoAtacado;
  final double precoCompra;
  final String codigo;
  final int estoqueAlerta;

  ProdutoVariacaoDto({
    required this.cor,
    required this.tamanho,
    required this.quantidade,
    required this.preco,
    required this.precoAtacado,
    required this.precoCompra,
    required this.codigo,
    required this.estoqueAlerta,
  });

  Map<String, dynamic> toJson() => {
    'cor': cor,
    'tamanho': tamanho,
    'quantidade': quantidade,
    'preco': preco,
    'precoAtacado': precoAtacado,
    'precoCompra': precoCompra,
    'codigo': codigo,
    'estoqueAlerta': estoqueAlerta,
  };
}
