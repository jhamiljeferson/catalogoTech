import 'package:flutter/material.dart';
import '../../models/PaginatedResponse.dart'; // Novo
import '../../models/categoria_model.dart';
import '../../services/categoria_service.dart';
import '../../widgets/categoria_tile.dart';
import 'categoria_form_screen.dart';

class CategoriaListScreen extends StatefulWidget {
  const CategoriaListScreen({Key? key}) : super(key: key);

  @override
  State<CategoriaListScreen> createState() => _CategoriaListScreenState();
}

class _CategoriaListScreenState extends State<CategoriaListScreen> {
  final CategoriaService _service = CategoriaService();
  int _currentPage = 0;
  PaginatedResponse<Categoria>? _paginado;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
  }

  Future<void> _carregarCategorias() async {
    try {
      final data = await _service.listarCategoriasPaginado(_currentPage);
      setState(() {
        _paginado = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar categorias')),
      );
    }
  }

  Future<void> _abrirFormulario({Categoria? categoria}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoriaFormScreen(categoria: categoria),
      ),
    );
    _carregarCategorias();
  }

  @override
  Widget build(BuildContext context) {
    final categorias = _paginado?.content ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return CategoriaTile(
                  categoria,
                  onEdit: (c) => _abrirFormulario(categoria: c),
                  onRefresh: _carregarCategorias,
                );
              },
            ),
          ),
          if (_paginado != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Wrap(
                spacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:
                        _paginado!.first
                            ? null
                            : () {
                              setState(() {
                                _currentPage--;
                              });
                              _carregarCategorias();
                            },
                    child: const Text('Anterior'),
                  ),
                  ElevatedButton(
                    onPressed:
                        _paginado!.last
                            ? null
                            : () {
                              setState(() {
                                _currentPage++;
                              });
                              _carregarCategorias();
                            },
                    child: const Text('Próxima'),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
