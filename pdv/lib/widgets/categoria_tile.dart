import 'package:flutter/material.dart';
import '../models/categoria_model.dart';
import '../services/categoria_service.dart';

class CategoriaTile extends StatelessWidget {
  final Categoria categoria;
  final void Function(Categoria) onEdit;
  final VoidCallback onRefresh;

  CategoriaTile(
    this.categoria, {
    required this.onEdit,
    required this.onRefresh,
  });

  final CategoriaService _service = CategoriaService();

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Excluir'),
            content: Text('Deseja realmente excluir esta categoria?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _service.deletarCategoria(categoria.id);
                  onRefresh();
                },
                child: Text('Confirmar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(categoria.nome),
      subtitle: Text(categoria.ativo ? 'Ativo' : 'Inativo'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => onEdit(categoria),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _confirmarExclusao(context),
          ),
        ],
      ),
    );
  }
}
