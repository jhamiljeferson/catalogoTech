import 'package:flutter/material.dart';
import '../../models/cor_model.dart';
import '../../services/cor_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/standard_button.dart';
import '../../widgets/standard_text_field.dart';

class CorFormScreen extends StatefulWidget {
  final Cor? cor;

  const CorFormScreen({Key? key, this.cor}) : super(key: key);

  @override
  State<CorFormScreen> createState() => _CorFormScreenState();
}

class _CorFormScreenState extends State<CorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = CorService();
  late final TextEditingController _nomeController;
  bool _ativo = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.cor?.nome);
    _ativo = widget.cor?.ativo ?? true;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final cor = Cor(
        id: widget.cor?.id,
        nome: _nomeController.text,
        ativo: _ativo,
      );

      if (widget.cor == null) {
        await _service.cadastrar(cor);
      } else {
        await _service.atualizar(cor);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.cor == null
                ? 'Cor cadastrada com sucesso!'
                : 'Cor atualizada com sucesso!',
          ),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar cor: $e'),
          backgroundColor: AppColors.error,
        ),
      );
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
          title: Text(widget.cor == null ? 'Nova Cor' : 'Editar Cor'),
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
                      return 'Por favor, insira o nome da cor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Ativo'),
                  value: _ativo,
                  onChanged: (bool value) {
                    setState(() {
                      _ativo = value;
                    });
                  },
                ),
                const Spacer(),
                StandardButton(
                  text: widget.cor == null ? 'Cadastrar' : 'Atualizar',
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
