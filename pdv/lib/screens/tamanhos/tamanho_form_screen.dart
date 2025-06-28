import 'package:flutter/material.dart';
import '../../models/tamanho_model.dart';
import '../../services/tamanho_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/standard_button.dart';
import '../../widgets/standard_text_field.dart';

class TamanhoFormScreen extends StatefulWidget {
  final Tamanho? tamanho;

  const TamanhoFormScreen({Key? key, this.tamanho}) : super(key: key);

  @override
  State<TamanhoFormScreen> createState() => _TamanhoFormScreenState();
}

class _TamanhoFormScreenState extends State<TamanhoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _service = TamanhoService();
  bool _isLoading = false;
  bool _ativo = true;

  @override
  void initState() {
    super.initState();
    if (widget.tamanho != null) {
      _nomeController.text = widget.tamanho!.nome;
      _ativo = widget.tamanho!.ativo;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final tamanho = Tamanho(
        id: widget.tamanho?.id,
        nome: _nomeController.text,
        ativo: _ativo,
      );

      if (widget.tamanho == null) {
        await _service.cadastrar(tamanho);
      } else {
        await _service.atualizar(tamanho);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.tamanho == null
                ? 'Tamanho cadastrado com sucesso!'
                : 'Tamanho atualizado com sucesso!',
          ),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar tamanho: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> _onWillPop() async {
    if (_nomeController.text.isEmpty) return true;

    return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Descartar alterações?'),
                content: const Text('As alterações não salvas serão perdidas.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Descartar'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.tamanho == null ? 'Novo Tamanho' : 'Editar Tamanho',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StandardTextField(
                  label: 'Nome',
                  controller: _nomeController,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do tamanho';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Ativo'),
                  value: _ativo,
                  onChanged: (value) => setState(() => _ativo = value),
                ),
                const Spacer(),
                StandardButton(
                  text: widget.tamanho == null ? 'Cadastrar' : 'Atualizar',
                  onPressed: _submitForm,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _service.dispose();
    super.dispose();
  }
}
