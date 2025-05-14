import 'package:flutter/material.dart';
import 'package:pdv/models/fornecedor/fornecedor_listagem_dto.dart';
import '../services/fornecedor_service.dart';

class FornecedorTile extends StatelessWidget {
  final FornecedorListagemDto fornecedor;
  final VoidCallback onEdit;
  final VoidCallback onRefresh;

  FornecedorTile(
    this.fornecedor, {
    required this.onEdit,
    required this.onRefresh,
  });

  final _service = FornecedorService();

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Excluir'),
            content: Text('Deseja realmente excluir este fornecedor?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _service.deletar(fornecedor.id);
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
      title: Text(fornecedor.nome),
      subtitle: Text(
        '${fornecedor.tipoPessoa.name} - ${fornecedor.email}- ${fornecedor.telefone}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _confirmarExclusao(context),
          ),
        ],
      ),
    );
  }
}
