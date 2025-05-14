class FornecedorAtualizacaoDto {
  final String? nome;
  final String? telefone;
  final String? email;
  final String? endereco;

  FornecedorAtualizacaoDto({
    this.nome,
    this.telefone,
    this.email,
    this.endereco,
  });

  Map<String, dynamic> toJson() {
    return {
      if (nome != null) 'nome': nome,
      if (telefone != null) 'telefone': telefone,
      if (email != null) 'email': email,
      if (endereco != null) 'endereco': endereco,
    };
  }
}
