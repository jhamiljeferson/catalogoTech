import 'package:flutter/material.dart';
import 'package:pdv/models/produto/produto_listagem_dto.dart';
import '../services/produto_service.dart';

class ProdutoTile extends StatelessWidget {
  final ProdutoListagemDto produto;
  final VoidCallback onEdit;
  final VoidCallback onDetail;
  final VoidCallback onRefresh;

  ProdutoTile(
    this.produto, {
    required this.onEdit,
    required this.onDetail,
    required this.onRefresh,
  });

  final _service = ProdutoService();

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Excluir'),
            content: Text(
              'Deseja realmente excluir o produto "${produto.nome}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await _service.deletar(produto.id);
                    onRefresh();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Produto excluído com sucesso'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Erro ao excluir produto')),
                    );
                  }
                },
                child: const Text('Confirmar'),
              ),
            ],
          ),
    );
  }

  String _formatarCores() {
    if (produto.cores.isEmpty) return 'Nenhuma cor';
    if (produto.cores.length <= 2) return produto.cores.join(', ');
    return '${produto.cores.take(2).join(', ')} +${produto.cores.length - 2}';
  }

  String _formatarTamanhos() {
    if (produto.tamanhos.isEmpty) return 'Nenhum tamanho';
    if (produto.tamanhos.length <= 3) return produto.tamanhos.join(', ');
    return '${produto.tamanhos.take(3).join(', ')} +${produto.tamanhos.length - 3}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200],
          backgroundImage:
              produto.imagemUrl != null
                  ? NetworkImage(produto.imagemUrl!)
                  : null,
          child:
              produto.imagemUrl == null
                  ? const Icon(Icons.image, color: Colors.grey)
                  : null,
        ),
        title: Text(
          produto.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código: ${produto.codigo}'),
            Text('Categoria: ${produto.categoria}'),
            Text('Fornecedor: ${produto.fornecedor}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.color_lens, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _formatarCores(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.format_size, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _formatarTamanhos(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.green),
              onPressed: onDetail,
              tooltip: 'Detalhar',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmarExclusao(context),
              tooltip: 'Excluir',
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
