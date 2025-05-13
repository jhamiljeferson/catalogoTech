class Categoria {
  final int id;
  final String nome;
  final bool ativo;

  Categoria({required this.id, required this.nome, required this.ativo});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(id: json['id'], nome: json['nome'], ativo: json['ativo']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'ativo': ativo};
  }
}
