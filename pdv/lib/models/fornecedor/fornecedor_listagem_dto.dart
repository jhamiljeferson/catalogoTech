import 'package:pdv/models/Fornecedor/tipo_pessoa.dart';

class FornecedorListagemDto {
  final int id;
  final String nome;
  final String telefone;
  final String email;
  final TipoPessoa tipoPessoa;

  FornecedorListagemDto({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.tipoPessoa,
  });

  factory FornecedorListagemDto.fromJson(Map<String, dynamic> json) {
    return FornecedorListagemDto(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
      email: json['email'],
      tipoPessoa: TipoPessoa.values.byName(json['tipoPessoa']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'tipoPessoa': tipoPessoa,
    };
  }
}
