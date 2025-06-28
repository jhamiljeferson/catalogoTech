import 'package:flutter/material.dart';
import '../../models/cor_model.dart';
import '../../services/cor_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/standard_card.dart';
import 'cor_form_screen.dart';

class CoresScreen extends StatefulWidget {
  const CoresScreen({Key? key}) : super(key: key);

  @override
  State<CoresScreen> createState() => _CoresScreenState();
}

class _CoresScreenState extends State<CoresScreen> {
  final CorService _service = CorService();
  final TextEditingController _searchController = TextEditingController();
  List<Cor> _cores = [];
  bool _isLoading = true;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _loadCores();
  }

  Future<void> _loadCores() async {
    setState(() => _isLoading = true);
    try {
      final cores = await _service.listarCores();
      setState(() {
        _cores = cores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar cores: $e')));
    }
  }

  Future<void> _deleteCor(Cor cor) async {
    try {
      await _service.deletar(cor.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cor removida com sucesso!')),
      );
      _loadCores();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao remover cor: $e')));
    }
  }

  Future<void> _navigateToForm([Cor? cor]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CorFormScreen(cor: cor)),
    );

    if (result == true) {
      _loadCores();
    }
  }

  List<Cor> get _filteredCores {
    if (_searchTerm.isEmpty) return _cores;
    return _cores
        .where(
          (cor) => cor.nome.toLowerCase().contains(_searchTerm.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cores'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar cores...',
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
        onRefresh: _loadCores,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCores.isEmpty
                ? Center(
                  child: Text(
                    _searchTerm.isEmpty
                        ? 'Nenhuma cor cadastrada'
                        : 'Nenhuma cor encontrada',
                    style: const TextStyle(fontSize: 16),
                  ),
                )
                : ListView.builder(
                  itemCount: _filteredCores.length,
                  itemBuilder: (context, index) {
                    final cor = _filteredCores[index];
                    return StandardCard(
                      title: cor.nome,
                      isActive: cor.ativo,
                      onTap: () => _navigateToForm(cor),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: AppColors.primary,
                          onPressed: () => _navigateToForm(cor),
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
                                        'Deseja realmente excluir esta cor?',
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
                                            _deleteCor(cor);
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
