class Tamanho {
  final int? id;
  final String nome;
  final bool ativo;

  Tamanho({this.id, required this.nome, this.ativo = true});

  factory Tamanho.fromJson(Map<String, dynamic> json) {
    return Tamanho(
      id: json['id'],
      nome: json['nome'],
      ativo: json['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'ativo': ativo};
  }

  Tamanho copyWith({int? id, String? nome, bool? ativo}) {
    return Tamanho(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      ativo: ativo ?? this.ativo,
    );
  }
}
