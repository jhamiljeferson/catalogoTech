import 'package:flutter/material.dart';

class VendasScreen extends StatefulWidget {
  @override
  _VendasScreenState createState() => _VendasScreenState();
}

class _VendasScreenState extends State<VendasScreen> {
  final _clienteController = TextEditingController();
  final _produtoController = TextEditingController();
  final _quantidadeController = TextEditingController();

  final List<Map<String, dynamic>> _vendas = [];

  void _adicionarVenda() {
    final cliente = _clienteController.text;
    final produto = _produtoController.text;
    final quantidade = int.tryParse(_quantidadeController.text) ?? 0;

    if (cliente.isEmpty || produto.isEmpty || quantidade <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    setState(() {
      _vendas.add({
        'cliente': cliente,
        'produto': produto,
        'quantidade': quantidade,
        'data': DateTime.now().toString().split(' ')[0],
      });
      _clienteController.clear();
      _produtoController.clear();
      _quantidadeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vendas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _clienteController,
              decoration: InputDecoration(labelText: 'Cliente'),
            ),
            TextField(
              controller: _produtoController,
              decoration: InputDecoration(labelText: 'Produto'),
            ),
            TextField(
              controller: _quantidadeController,
              decoration: InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _adicionarVenda,
              child: Text('Registrar Venda'),
            ),
            Divider(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _vendas.length,
                itemBuilder: (context, index) {
                  final venda = _vendas[index];
                  return ListTile(
                    leading: Icon(Icons.shopping_bag),
                    title: Text('${venda['produto']} - ${venda['cliente']}'),
                    subtitle: Text(
                      'Qtd: ${venda['quantidade']} • ${venda['data']}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
