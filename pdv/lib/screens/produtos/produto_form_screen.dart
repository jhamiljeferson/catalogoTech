import 'package:flutter/material.dart';
import 'package:pdv/models/produto/produto_cadastro_dto.dart';
import 'package:pdv/models/produto/produto_variacao_dto.dart';
import 'package:pdv/services/produto_service.dart';
import 'package:pdv/services/categoria_service.dart';
import 'package:pdv/services/fornecedor_service.dart';
import 'package:pdv/services/cor_service.dart';
import 'package:pdv/services/tamanho_service.dart';
import 'package:pdv/models/categoria_model.dart';
import 'package:pdv/models/fornecedor/fornecedor_listagem_dto.dart';
import 'package:pdv/models/cor_model.dart';
import 'package:pdv/models/tamanho_model.dart';

class ProdutoFormScreen extends StatefulWidget {
  const ProdutoFormScreen({Key? key}) : super(key: key);

  @override
  State<ProdutoFormScreen> createState() => _ProdutoFormScreenState();
}

class _ProdutoFormScreenState extends State<ProdutoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _codigoController = TextEditingController();
  final _fotoController = TextEditingController();

  Categoria? _categoriaSelecionada;
  FornecedorListagemDto? _fornecedorSelecionado;
  List<Cor> _coresDisponiveis = [];
  List<Tamanho> _tamanhosDisponiveis = [];
  List<Cor> _coresSelecionadas = [];
  List<Tamanho> _tamanhosSelecionados = [];

  bool _loading = false;
  final ProdutoService _produtoService = ProdutoService();

  // Estrutura: {cor: {tamanho: campos}}
  Map<String, Map<String, Map<String, dynamic>>> _variacoes = {};

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  Future<void> _carregarDadosIniciais() async {
    final cores = await CorService().listarCores();
    final tamanhos = await TamanhoService().listarTamanhos();
    setState(() {
      _coresDisponiveis = cores;
      _tamanhosDisponiveis = tamanhos;
    });
  }

  void _onCorTamanhoSelecionados() {
    // Garante que toda combinação cor+tamanho tenha um map de campos
    for (final cor in _coresSelecionadas) {
      _variacoes.putIfAbsent(cor.nome, () => {});
      for (final tam in _tamanhosSelecionados) {
        _variacoes[cor.nome]!.putIfAbsent(
          tam.nome,
          () => {
            'quantidade': 0,
            'preco': 0.0,
            'precoAtacado': 0.0,
            'precoCompra': 0.0,
            'codigo': '${cor.nome}-${tam.nome}',
            'estoqueAlerta': 0,
          },
        );
      }
    }
    // Remove variações de cores/tamanhos não mais selecionados
    _variacoes.removeWhere(
      (cor, map) => !_coresSelecionadas.any((c) => c.nome == cor),
    );
    for (final cor in _variacoes.keys) {
      _variacoes[cor]!.removeWhere(
        (tam, _) => !_tamanhosSelecionados.any((t) => t.nome == tam),
      );
    }
    setState(() {});
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoriaSelecionada == null || _fornecedorSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione categoria e fornecedor')),
      );
      return;
    }
    if (_coresSelecionadas.isEmpty || _tamanhosSelecionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos uma cor e um tamanho'),
        ),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final variacoes = <ProdutoVariacaoDto>[];
      _variacoes.forEach((cor, tamanhos) {
        tamanhos.forEach((tam, campos) {
          variacoes.add(
            ProdutoVariacaoDto(
              cor: cor,
              tamanho: tam,
              quantidade: int.tryParse(campos['quantidade'].toString()) ?? 0,
              preco: double.tryParse(campos['preco'].toString()) ?? 0.0,
              precoAtacado:
                  double.tryParse(campos['precoAtacado'].toString()) ?? 0.0,
              precoCompra:
                  double.tryParse(campos['precoCompra'].toString()) ?? 0.0,
              codigo: campos['codigo'] ?? '',
              estoqueAlerta:
                  int.tryParse(campos['estoqueAlerta'].toString()) ?? 0,
            ),
          );
        });
      });
      final dto = ProdutoCadastroDto(
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        codigo: _codigoController.text,
        categoriaId: _categoriaSelecionada!.id,
        fornecedorId: _fornecedorSelecionado!.id,
        foto: _fotoController.text,
        cores: _coresSelecionadas.map((c) => c.nome).toList(),
        tamanhos: _tamanhosSelecionados.map((t) => t.nome).toList(),
        variacoes: variacoes,
      );
      await _produtoService.cadastrarProduto(dto);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao salvar produto')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Produto')),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator:
                      (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator:
                      (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
                TextFormField(
                  controller: _codigoController,
                  decoration: const InputDecoration(labelText: 'Código'),
                  validator:
                      (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
                _DropdownCategoria(
                  onChanged:
                      (cat) => setState(() => _categoriaSelecionada = cat),
                  selecionada: _categoriaSelecionada,
                ),
                _DropdownFornecedor(
                  onChanged: (f) => setState(() => _fornecedorSelecionado = f),
                  selecionado: _fornecedorSelecionado,
                ),
                TextFormField(
                  controller: _fotoController,
                  decoration: const InputDecoration(labelText: 'URL da Foto'),
                  validator:
                      (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                _MultiSelect<Cor>(
                  label: 'Cores',
                  items: _coresDisponiveis,
                  selecionados: _coresSelecionadas,
                  onChanged: (list) {
                    _coresSelecionadas = list;
                    _onCorTamanhoSelecionados();
                  },
                  itemLabel: (c) => c.nome,
                ),
                _MultiSelect<Tamanho>(
                  label: 'Tamanhos',
                  items: _tamanhosDisponiveis,
                  selecionados: _tamanhosSelecionados,
                  onChanged: (list) {
                    _tamanhosSelecionados = list;
                    _onCorTamanhoSelecionados();
                  },
                  itemLabel: (t) => t.nome,
                ),
                const SizedBox(height: 16),
                ..._coresSelecionadas.map(
                  (cor) => _CardCorVariacoes(
                    cor: cor.nome,
                    tamanhos: _tamanhosSelecionados.map((t) => t.nome).toList(),
                    campos: _variacoes[cor.nome] ?? {},
                    onChanged: (tam, campo, valor) {
                      _variacoes[cor.nome]![tam]![campo] = valor;
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_loading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _loading ? null : _salvar,
            child: const Text('Salvar'),
          ),
        ),
      ),
    );
  }
}

// MultiSelect Widget
class _MultiSelect<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final List<T> selecionados;
  final void Function(List<T>) onChanged;
  final String Function(T) itemLabel;

  const _MultiSelect({
    required this.label,
    required this.items,
    required this.selecionados,
    required this.onChanged,
    required this.itemLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children:
              items.map((item) {
                final selected = selecionados.contains(item);
                return FilterChip(
                  label: Text(itemLabel(item)),
                  selected: selected,
                  onSelected: (v) {
                    final novaLista = List<T>.from(selecionados);
                    if (v) {
                      novaLista.add(item);
                    } else {
                      novaLista.remove(item);
                    }
                    onChanged(novaLista);
                  },
                );
              }).toList(),
        ),
      ],
    );
  }
}

// Card de variações por cor
class _CardCorVariacoes extends StatefulWidget {
  final String cor;
  final List<String> tamanhos;
  final Map<String, Map<String, dynamic>> campos;
  final void Function(String tamanho, String campo, dynamic valor) onChanged;

  const _CardCorVariacoes({
    required this.cor,
    required this.tamanhos,
    required this.campos,
    required this.onChanged,
  });

  @override
  State<_CardCorVariacoes> createState() => _CardCorVariacoesState();
}

class _CardCorVariacoesState extends State<_CardCorVariacoes> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text('Cor: ${widget.cor}'),
        initiallyExpanded: _expanded,
        onExpansionChanged: (v) => setState(() => _expanded = v),
        children:
            widget.tamanhos.map((tam) {
              final campos = widget.campos[tam] ?? {};
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tamanho: $tam',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        _CampoNum(
                          label: 'Qtde',
                          valor: campos['quantidade'] ?? 0,
                          onChanged:
                              (v) => widget.onChanged(tam, 'quantidade', v),
                        ),
                        const SizedBox(width: 8),
                        _CampoNum(
                          label: 'Venda',
                          valor: campos['preco'] ?? 0.0,
                          onChanged: (v) => widget.onChanged(tam, 'preco', v),
                        ),
                        const SizedBox(width: 8),
                        _CampoNum(
                          label: 'Atacado',
                          valor: campos['precoAtacado'] ?? 0.0,
                          onChanged:
                              (v) => widget.onChanged(tam, 'precoAtacado', v),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _CampoNum(
                          label: 'Compra',
                          valor: campos['precoCompra'] ?? 0.0,
                          onChanged:
                              (v) => widget.onChanged(tam, 'precoCompra', v),
                        ),
                        const SizedBox(width: 8),
                        _CampoText(
                          label: 'Codigo',
                          valor: campos['codigo'] ?? '',
                          onChanged: (v) => widget.onChanged(tam, 'codigo', v),
                        ),
                        const SizedBox(width: 8),
                        _CampoNum(
                          label: 'Estoque',
                          valor: campos['estoqueAlerta'] ?? 0,
                          onChanged:
                              (v) => widget.onChanged(tam, 'estoqueAlerta', v),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}

class _CampoNum extends StatelessWidget {
  final String label;
  final dynamic valor;
  final void Function(dynamic) onChanged;

  const _CampoNum({
    required this.label,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: TextFormField(
        initialValue: valor.toString(),
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number,
        onChanged: (v) => onChanged(num.tryParse(v) ?? 0),
      ),
    );
  }
}

class _CampoText extends StatelessWidget {
  final String label;
  final String valor;
  final void Function(String) onChanged;

  const _CampoText({
    required this.label,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: TextFormField(
        initialValue: valor,
        decoration: InputDecoration(labelText: label),
        onChanged: onChanged,
      ),
    );
  }
}

// Dropdowns de categoria e fornecedor
class _DropdownCategoria extends StatefulWidget {
  final void Function(Categoria?) onChanged;
  final Categoria? selecionada;
  const _DropdownCategoria({required this.onChanged, this.selecionada});
  @override
  State<_DropdownCategoria> createState() => _DropdownCategoriaState();
}

class _DropdownCategoriaState extends State<_DropdownCategoria> {
  List<Categoria> _categorias = [];
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    CategoriaService().listarCategoriasPaginado(0).then((res) {
      setState(() {
        _categorias = res.content;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const CircularProgressIndicator();
    return DropdownButtonFormField<Categoria>(
      value: widget.selecionada,
      items:
          _categorias
              .map((c) => DropdownMenuItem(value: c, child: Text(c.nome)))
              .toList(),
      onChanged: widget.onChanged,
      decoration: const InputDecoration(labelText: 'Categoria'),
      validator: (v) => v == null ? 'Obrigatório' : null,
    );
  }
}

class _DropdownFornecedor extends StatefulWidget {
  final void Function(FornecedorListagemDto?) onChanged;
  final FornecedorListagemDto? selecionado;
  const _DropdownFornecedor({required this.onChanged, this.selecionado});
  @override
  State<_DropdownFornecedor> createState() => _DropdownFornecedorState();
}

class _DropdownFornecedorState extends State<_DropdownFornecedor> {
  List<FornecedorListagemDto> _fornecedores = [];
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    FornecedorService().listarPaginado(0).then((res) {
      setState(() {
        _fornecedores = res.content;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const CircularProgressIndicator();
    return DropdownButtonFormField<FornecedorListagemDto>(
      value: widget.selecionado,
      items:
          _fornecedores
              .map((f) => DropdownMenuItem(value: f, child: Text(f.nome)))
              .toList(),
      onChanged: widget.onChanged,
      decoration: const InputDecoration(labelText: 'Fornecedor'),
      validator: (v) => v == null ? 'Obrigatório' : null,
    );
  }
}
