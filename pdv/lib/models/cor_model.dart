class Cor {
  final int? id;
  final String nome;
  final bool ativo;

  Cor({this.id, required this.nome, this.ativo = true});

  factory Cor.fromJson(Map<String, dynamic> json) {
    return Cor(
      id: json['id'],
      nome: json['nome'],
      ativo: json['ativo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'ativo': ativo};
  }

  Cor copyWith({int? id, String? nome, bool? ativo}) {
    return Cor(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      ativo: ativo ?? this.ativo,
    );
  }
}
