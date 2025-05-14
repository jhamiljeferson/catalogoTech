import 'package:pdv/models/fornecedor/tipo_pessoa.dart';

class FornecedorDetalhamentoDto {
  final int id;
  final String nome;
  final String cpf;
  final String telefone;
  final String email;
  final String endereco;
  final DateTime data;
  final TipoPessoa tipoPessoa;

  FornecedorDetalhamentoDto({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.email,
    required this.endereco,
    required this.data,
    required this.tipoPessoa,
  });

  factory FornecedorDetalhamentoDto.fromJson(Map<String, dynamic> json) {
    return FornecedorDetalhamentoDto(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      telefone: json['telefone'],
      email: json['email'],
      endereco: json['endereco'],
      data: DateTime.parse(json['data']),
      tipoPessoa: TipoPessoa.values.byName(json['tipoPessoa']),
    );
  }
}
