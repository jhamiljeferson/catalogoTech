import 'package:flutter/material.dart';
import 'package:pdv/models/fornecedor/fornecedor_listagem_dto.dart';
import 'package:pdv/models/PaginatedResponse.dart';
import 'package:pdv/screens/fornecedores/fornecedor_form_screen.dart';
import 'package:pdv/services/fornecedor_service.dart';
import 'package:pdv/widgets/fornecedor_tile.dart';

class FornecedorListScreen extends StatefulWidget {
  const FornecedorListScreen({Key? key}) : super(key: key);

  @override
  State<FornecedorListScreen> createState() => _FornecedorListScreenState();
}

class _FornecedorListScreenState extends State<FornecedorListScreen> {
  final FornecedorService _service = FornecedorService();
  int _currentPage = 0;
  PaginatedResponse<FornecedorListagemDto>? _paginado;

  @override
  void initState() {
    super.initState();
    _carregarFornecedores();
  }

  Future<void> _carregarFornecedores() async {
    try {
      final data = await _service.listarPaginado(_currentPage);
      setState(() {
        _paginado = data;
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar fornecedores')),
      );
    }
  }

  Future<void> _abrirFormulario({FornecedorListagemDto? fornecedor}) async {
    if (fornecedor == null) {
      // Novo cadastro
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FornecedorFormScreen()),
      );
    } else {
      try {
        final detalhado = await _service.buscarPorId(fornecedor.id);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FornecedorFormScreen(fornecedor: detalhado),
          ),
        );
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao carregar fornecedor')),
        );
      }
    }
    _carregarFornecedores();
  }

  @override
  Widget build(BuildContext context) {
    final fornecedores = _paginado?.content ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Fornecedores')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: fornecedores.length,
              itemBuilder: (context, index) {
                final f = fornecedores[index];
                return FornecedorTile(
                  f,
                  onEdit: () => _abrirFormulario(fornecedor: f),
                  onRefresh: _carregarFornecedores,
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
                              setState(() => _currentPage--);
                              _carregarFornecedores();
                            },
                    child: const Text('Anterior'),
                  ),
                  ElevatedButton(
                    onPressed:
                        _paginado!.last
                            ? null
                            : () {
                              setState(() => _currentPage++);
                              _carregarFornecedores();
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
