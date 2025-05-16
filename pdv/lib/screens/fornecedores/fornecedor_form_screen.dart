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

  static const String campoObrigatorio = 'Campo obrigatório';
  static const String erroSalvar = 'Erro ao salvar fornecedor';

  @override
  void initState() {
    super.initState();
    if (widget.fornecedor != null) {
      _preencherCampos(widget.fornecedor!);
    }
  }

  void _preencherCampos(FornecedorDetalhamentoDto fornecedor) {
    _nomeController.text = fornecedor.nome;
    _cpfController.text = fornecedor.cpf ?? '';
    _emailController.text = fornecedor.email ?? '';
    _telefoneController.text = fornecedor.telefone ?? '';
    _enderecoController.text = fornecedor.endereco ?? '';
    _tipoPessoa = fornecedor.tipoPessoa;
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.fornecedor == null) {
          await _cadastrarFornecedor();
        } else {
          await _atualizarFornecedor();
        }
        Navigator.pop(context);
      } catch (_) {
        _exibirMensagemErro();
      }
    }
  }

  Future<void> _cadastrarFornecedor() async {
    final novo = FornecedorCadastroDto(
      nome: _nomeController.text,
      cpf: _cpfController.text,
      email: _emailController.text,
      telefone: _telefoneController.text,
      endereco: _enderecoController.text,
      tipoPessoa: _tipoPessoa,
    );
    await _service.cadastrar(novo);
  }

  Future<void> _atualizarFornecedor() async {
    final atualizado = FornecedorAtualizacaoDto(
      nome: _nomeController.text,
      email: _emailController.text,
      telefone: _telefoneController.text,
      endereco: _enderecoController.text,
    );
    await _service.atualizar(widget.fornecedor!.id, atualizado);
  }

  void _exibirMensagemErro() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(erroSalvar)));
  }

  String? _validarCampoObrigatorio(String? value) {
    return (value == null || value.isEmpty) ? campoObrigatorio : null;
  }

  String? _validarCpfCnpj(String? value) {
    final regexCpfCnpj = RegExp(r'^\d{11}$|^\d{14}$');
    return (value != null && !regexCpfCnpj.hasMatch(value))
        ? 'CPF/CNPJ inválido'
        : null;
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
              _buildTextFormField(
                _nomeController,
                'Nome',
                _validarCampoObrigatorio,
              ),
              _buildTextFormField(_cpfController, 'CPF/CNPJ', _validarCpfCnpj),
              _buildTextFormField(
                _emailController,
                'Email',
                _validarCampoObrigatorio,
              ),
              _buildTextFormField(
                _telefoneController,
                'Telefone',
                _validarCampoObrigatorio,
              ),
              _buildTextFormField(
                _enderecoController,
                'Endereço',
                _validarCampoObrigatorio,
              ),
              _buildDropdownTipoPessoa(),
              _buildSwitchAtivo(),
              const SizedBox(height: 20),
              _buildSalvarButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label,
    String? Function(String?)? validator,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }

  Widget _buildDropdownTipoPessoa() {
    return DropdownButtonFormField<TipoPessoa>(
      value: _tipoPessoa,
      items:
          TipoPessoa.values
              .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
              .toList(),
      onChanged: (val) => setState(() => _tipoPessoa = val!),
      decoration: const InputDecoration(labelText: 'Tipo Pessoa'),
    );
  }

  Widget _buildSwitchAtivo() {
    return SwitchListTile(
      title: const Text('Ativo'),
      value: _ativo,
      onChanged: (val) => setState(() => _ativo = val),
    );
  }

  Widget _buildSalvarButton() {
    return ElevatedButton(onPressed: _salvar, child: const Text('Salvar'));
  }
}
