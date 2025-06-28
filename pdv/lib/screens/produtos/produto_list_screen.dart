import 'package:flutter/material.dart';
import 'package:pdv/models/produto/produto_listagem_dto.dart';
import 'package:pdv/models/PaginatedResponse.dart';
import 'package:pdv/services/produto_service.dart';
import 'package:pdv/widgets/produto_tile.dart';
import 'package:go_router/go_router.dart';

class ProdutoListScreen extends StatefulWidget {
  const ProdutoListScreen({Key? key}) : super(key: key);

  @override
  State<ProdutoListScreen> createState() => _ProdutoListScreenState();
}

class _ProdutoListScreenState extends State<ProdutoListScreen> {
  final ProdutoService _service = ProdutoService();
  int _currentPage = 0;
  PaginatedResponse<ProdutoListagemDto>? _paginado;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _service.listarPaginado(_currentPage);
      setState(() {
        _paginado = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao carregar produtos')),
        );
      }
    }
  }

  void _abrirDetalhes(ProdutoListagemDto produto) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(produto.nome),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (produto.imagemUrl != null)
                    Center(
                      child: Image.network(
                        produto.imagemUrl!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 50),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text('Código: ${produto.codigo}'),
                  Text('Categoria: ${produto.categoria}'),
                  Text('Fornecedor: ${produto.fornecedor}'),
                  Text('Status: ${produto.ativo ? "Ativo" : "Inativo"}'),
                  const SizedBox(height: 8),
                  Text('Cores: ${produto.cores.join(", ")}'),
                  Text('Tamanhos: ${produto.tamanhos.join(", ")}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          ),
    );
  }

  void _abrirFormulario({ProdutoListagemDto? produto}) {
    // TODO: Implementar tela de formulário de produtos
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de edição em desenvolvimento'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produtos = _paginado?.content ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarProdutos,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  if (_paginado != null && produtos.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total de produtos: ${_paginado!.totalElements}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Expanded(
                    child:
                        produtos.isEmpty
                            ? const Center(
                              child: Text(
                                'Nenhum produto encontrado',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                            : ListView.builder(
                              itemCount: produtos.length,
                              itemBuilder: (context, index) {
                                final produto = produtos[index];
                                return ProdutoTile(
                                  produto,
                                  onEdit:
                                      () => _abrirFormulario(produto: produto),
                                  onDetail: () => _abrirDetalhes(produto),
                                  onRefresh: _carregarProdutos,
                                );
                              },
                            ),
                  ),
                  if (_paginado != null && _paginado!.totalPages > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed:
                                _paginado!.first
                                    ? null
                                    : () {
                                      setState(() => _currentPage--);
                                      _carregarProdutos();
                                    },
                            child: const Text('Anterior'),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Página ${_currentPage + 1} de ${_paginado!.totalPages}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed:
                                _paginado!.last
                                    ? null
                                    : () {
                                      setState(() => _currentPage++);
                                      _carregarProdutos();
                                    },
                            child: const Text('Próxima'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/dashboard/produtos/novo'),
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Produto',
      ),
    );
  }
}
