import 'package:pdv/models/fornecedor/tipo_pessoa.dart';

class FornecedorCadastroDto {
  final String nome;
  final String cpf;
  final String telefone;
  final String email;
  final String endereco;
  final TipoPessoa tipoPessoa;

  FornecedorCadastroDto({
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.email,
    required this.endereco,
    required this.tipoPessoa,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'email': email,
      'endereco': endereco,
      'tipoPessoa': tipoPessoa.name,
    };
  }
}
