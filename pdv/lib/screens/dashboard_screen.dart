import 'package:flutter/material.dart';
import 'package:pdv/screens/vendas_screen.dart';
import '../services/auth_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pdv/screens/categoria/categoria_list_screen.dart';
import 'package:pdv/screens/cores/cores_screen.dart';
import 'package:pdv/screens/fornecedores/fornecedor_list_screen.dart';
import 'package:pdv/screens/login_screen.dart';
import 'package:pdv/screens/produtos/produto_list_screen.dart';
import 'package:pdv/screens/tamanhos/tamanhos_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _logout(BuildContext context) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.logout();
    if (mounted) {
      context.go('/login');
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    //final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text("Menu")),

            // Vendas
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Vendas'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => VendasScreen()),
                  ),
            ),

            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Estoque",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Produtos'),
              onTap: () => context.go('/dashboard/produtos'),
            ),
            ListTile(
              leading: Icon(Icons.widgets),
              title: Text('Variações'),
              onTap: () => context.go('/dashboard/variacoes'),
            ),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text('Cores'),
              onTap: () => context.go('/dashboard/cores'),
            ),
            ListTile(
              leading: Icon(Icons.format_size),
              title: Text('Tamanhos'),
              onTap: () => context.go('/dashboard/tamanhos'),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categorias'),
              onTap: () => context.go('/dashboard/categorias'),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Fornecedores'),
              onTap: () => context.go('/dashboard/fornecedores'),
            ),

            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Financeiro",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Contas a Pagar'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RelatoriosScreen()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text('Contas a Receber'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RelatoriosScreen()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.money),
              title: Text('Sangrias'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RelatoriosScreen()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.inventory_2),
              title: Text('Saídas de Produto'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RelatoriosScreen()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.inventory_2_outlined),
              title: Text('Entradas de Produto'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RelatoriosScreen()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.compare_arrows),
              title: Text('Trocas'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RelatoriosScreen()),
                  ),
            ),

            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Cadastros",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Usuários'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RelatoriosScreen()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Clientes'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RelatoriosScreen()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('Cargos'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RelatoriosScreen()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Formas de Pagamento'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RelatoriosScreen()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.repeat),
              title: Text('Frequências'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RelatoriosScreen()),
                  ),
            ),

            Divider(),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Relatórios'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RelatoriosScreen()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ConfigScreen()),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: Text('Dashboard'),
        leading: IconButton(icon: Icon(Icons.menu), onPressed: _openDrawer),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              bool confirm = await showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: Text('Sair'),
                      content: Text('Deseja realmente sair?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Sair'),
                        ),
                      ],
                    ),
              );

              if (confirm) await _logout(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _InfoCard(label: 'Total de Clientes', value: '124'),
                _InfoCard(label: 'A Receber Hoje', value: 'R\$ 1.200,00'),
                _InfoCard(label: 'A Pagar Hoje', value: 'R\$ 800,00'),
                _InfoCard(label: 'Vendas de Hoje', value: 'R\$ 3.000,00'),
                _InfoCard(label: 'Saldo de Hoje', value: 'R\$ 2.200,00'),
                _InfoCard(label: 'Estoque Baixo', value: '5 Itens'),
                _InfoCard(label: 'Pagamentos Vencidos', value: 'R\$ 600,00'),
                _InfoCard(label: 'Contas a Pagar', value: 'R\$ 4.000,00'),
                _InfoCard(
                  label: 'Recebimentos Vencidos',
                  value: 'R\$ 1.500,00',
                ),
                _InfoCard(label: 'Saldo do Mês', value: 'R\$ 12.000,00'),
              ],
            ),
            SizedBox(height: 30),
            Container(
              height: 300,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: FaturamentoMensalChart(),
            ),
          ],
        ),
      ),
    );
  }
}

class FaturamentoMensalChart extends StatelessWidget {
  final List<double> valores = [
    12000,
    13500,
    11000,
    14500,
    16000,
    17500,
    19000,
    18500,
    17000,
    20000,
    21000,
    22000,
  ];

  final List<String> meses = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 25000,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                int index = value.toInt();
                return Text(
                  index >= 0 && index < meses.length ? meses[index] : '',
                  style: TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups:
            valores.asMap().entries.map((entry) {
              int i = entry.key;
              double val = entry.value;
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: val,
                    color: Colors.blueAccent,
                    width: 14,
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 100,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Spacer(),
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VariacoesScreen extends StatelessWidget {
  const VariacoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class RelatoriosScreen extends StatelessWidget {
  const RelatoriosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
