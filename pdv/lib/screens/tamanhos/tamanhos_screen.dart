import 'package:flutter/material.dart';
import '../../models/tamanho_model.dart';
import '../../services/tamanho_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/standard_card.dart';
import 'tamanho_form_screen.dart';

class TamanhosScreen extends StatefulWidget {
  const TamanhosScreen({Key? key}) : super(key: key);

  @override
  State<TamanhosScreen> createState() => _TamanhosScreenState();
}

class _TamanhosScreenState extends State<TamanhosScreen> {
  final TamanhoService _service = TamanhoService();
  final TextEditingController _searchController = TextEditingController();
  List<Tamanho> _tamanhos = [];
  bool _isLoading = true;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _loadTamanhos();
  }

  Future<void> _loadTamanhos() async {
    setState(() => _isLoading = true);
    try {
      final tamanhos = await _service.listarTamanhos();
      setState(() {
        _tamanhos = tamanhos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar tamanhos: $e')));
    }
  }

  Future<void> _deleteTamanho(Tamanho tamanho) async {
    try {
      await _service.deletar(tamanho.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tamanho removido com sucesso!')),
      );
      _loadTamanhos();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao remover tamanho: $e')));
    }
  }

  Future<void> _navigateToForm([Tamanho? tamanho]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TamanhoFormScreen(tamanho: tamanho)),
    );

    if (result == true) {
      _loadTamanhos();
    }
  }

  List<Tamanho> get _filteredTamanhos {
    if (_searchTerm.isEmpty) return _tamanhos;
    return _tamanhos
        .where(
          (tamanho) =>
              tamanho.nome.toLowerCase().contains(_searchTerm.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tamanhos'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar tamanhos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => setState(() => _searchTerm = value),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTamanhos,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTamanhos.isEmpty
                ? Center(
                  child: Text(
                    _searchTerm.isEmpty
                        ? 'Nenhum tamanho cadastrado'
                        : 'Nenhum tamanho encontrado',
                    style: const TextStyle(fontSize: 16),
                  ),
                )
                : ListView.builder(
                  itemCount: _filteredTamanhos.length,
                  itemBuilder: (context, index) {
                    final tamanho = _filteredTamanhos[index];
                    return StandardCard(
                      title: tamanho.nome,
                      isActive: tamanho.ativo,
                      onTap: () => _navigateToForm(tamanho),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: AppColors.primary,
                          onPressed: () => _navigateToForm(tamanho),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: AppColors.error,
                          onPressed:
                              () => showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Confirmar exclusão'),
                                      content: const Text(
                                        'Deseja realmente excluir este tamanho?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _deleteTamanho(tamanho);
                                          },
                                          child: const Text('Excluir'),
                                        ),
                                      ],
                                    ),
                              ),
                        ),
                      ],
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _service.dispose();
    super.dispose();
  }
}
