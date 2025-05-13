import 'package:flutter/material.dart';
import '../../models/categoria_model.dart';
import '../../services/categoria_service.dart';
import '../../widgets/categoria_tile.dart';
import 'categoria_form_screen.dart';

class CategoriaListScreen extends StatefulWidget {
  @override
  _CategoriaListScreenState createState() => _CategoriaListScreenState();
}

class _CategoriaListScreenState extends State<CategoriaListScreen> {
  final CategoriaService _service = CategoriaService();
  late Future<List<Categoria>> _categorias;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
  }

  void _carregarCategorias() {
    setState(() {
      _categorias = _service.listarCategorias();
    });
  }

  void _abrirFormulario({Categoria? categoria}) async {
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
    return Scaffold(
      appBar: AppBar(title: Text('Categorias')),
      body: FutureBuilder<List<Categoria>>(
        future: _categorias,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final categorias = snapshot.data!;
            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder:
                  (context, index) => CategoriaTile(
                    categorias[index],
                    onEdit:
                        (categoria) => _abrirFormulario(categoria: categoria),
                    onRefresh: _carregarCategorias,
                  ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: Icon(Icons.add),
      ),
    );
  }
}
