import 'package:flutter/material.dart';
import 'package:pdv/models/fornecedor/fornecedor_atualizacao_dto.dart';
import 'package:pdv/models/fornecedor/fornecedor_cadastro_dto.dart';
import 'package:pdv/models/fornecedor/fornecedor_detalhamento_dto.dart';
import 'package:pdv/models/fornecedor/tipo_pessoa.dart';
import '../../services/fornecedor_service.dart';

class FornecedorFormScreen extends StatefulWidget {
  final FornecedorDetalhamentoDto? fornecedor;

  const FornecedorFormScreen({Key? key, this.fornecedor}) : super(key: key);

  @override
  State<FornecedorFormScreen> createState() => _FornecedorFormScreenState();
}

class _FornecedorFormScreenState extends State<FornecedorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();

  TipoPessoa _tipoPessoa = TipoPessoa.FISICA;
  bool _ativo = true;

  final FornecedorService _service = FornecedorService();

  @override
  void initState() {
    super.initState();
    if (widget.fornecedor != null) {
      final f = widget.fornecedor!;
      _nomeController.text = f.nome;
      _cpfController.text = f.cpf ?? '';
      _emailController.text = f.email ?? '';
      _telefoneController.text = f.telefone ?? '';
      _enderecoController.text = f.endereco ?? '';
      _tipoPessoa = f.tipoPessoa;
    }
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.fornecedor == null) {
          final novo = FornecedorCadastroDto(
            nome: _nomeController.text,
            cpf: _cpfController.text,
            email: _emailController.text,
            telefone: _telefoneController.text,
            endereco: _enderecoController.text,
            tipoPessoa: _tipoPessoa,
          );
          await _service.cadastrar(novo);
        } else {
          final atualizado = FornecedorAtualizacaoDto(
            nome: _nomeController.text,
            email: _emailController.text,
            telefone: _telefoneController.text,
            endereco: _enderecoController.text,
          );
          await _service.atualizar(widget.fornecedor!.id, atualizado);
        }

        Navigator.pop(context);
      } catch (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar fornecedor')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.fornecedor != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Fornecedor' : 'Novo Fornecedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo obrigatório'
                            : null,
              ),
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(labelText: 'CPF/CNPJ'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
              ),
              DropdownButtonFormField<TipoPessoa>(
                value: _tipoPessoa,
                items:
                    TipoPessoa.values
                        .map(
                          (e) =>
                              DropdownMenuItem(value: e, child: Text(e.name)),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _tipoPessoa = val!),
                decoration: InputDecoration(labelText: 'Tipo Pessoa'),
              ),
              SwitchListTile(
                title: Text('Ativo'),
                value: _ativo,
                onChanged: (val) => setState(() => _ativo = val),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _salvar, child: Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
