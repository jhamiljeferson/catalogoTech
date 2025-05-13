import 'package:flutter/material.dart';
import '../../models/categoria_model.dart';
import '../../services/categoria_service.dart';

class CategoriaFormScreen extends StatefulWidget {
  final Categoria? categoria;

  CategoriaFormScreen({this.categoria});

  @override
  _CategoriaFormScreenState createState() => _CategoriaFormScreenState();
}

class _CategoriaFormScreenState extends State<CategoriaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  bool _ativo = true;

  final CategoriaService _service = CategoriaService();

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      _nomeController.text = widget.categoria!.nome;
      _ativo = widget.categoria!.ativo;
    }
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final categoria = Categoria(
        id: widget.categoria?.id ?? 0,
        nome: _nomeController.text,
        ativo: _ativo,
      );

      try {
        if (widget.categoria == null) {
          await _service.cadastrarCategoria(categoria);
        } else {
          await _service.atualizarCategoria(categoria);
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.categoria != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Categoria' : 'Nova Categoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
