import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdv/screens/cores/cores_screen.dart';
import 'package:pdv/screens/tamanhos/tamanhos_screen.dart';
import 'package:provider/provider.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/categoria/categoria_list_screen.dart';
import '../screens/fornecedores/fornecedor_list_screen.dart';
import '../screens/vendas_screen.dart';
import '../screens/produtos/produto_list_screen.dart';
import '../screens/produtos/produto_form_screen.dart';
import '../services/auth_service.dart';

final goRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final loggedIn = context.read<AuthService>().token != null;

    if (!loggedIn && !state.matchedLocation.startsWith('/login')) {
      return '/login';
    }

    if (loggedIn && state.matchedLocation == '/login') {
      return '/dashboard';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => DashboardScreen(),
      routes: [
        GoRoute(
          path: 'categorias',
          builder: (context, state) => CategoriaListScreen(),
        ),
        GoRoute(
          path: 'fornecedores',
          builder: (context, state) => FornecedorListScreen(),
        ),
        GoRoute(path: 'cores', builder: (context, state) => CoresScreen()),
        GoRoute(
          path: 'tamanhos',
          builder: (context, state) => TamanhosScreen(),
        ),
        GoRoute(path: 'vendas', builder: (context, state) => VendasScreen()),
        GoRoute(
          path: 'produtos',
          builder: (context, state) => ProdutoListScreen(),
        ),
        GoRoute(
          path: 'produtos/novo',
          builder: (context, state) => ProdutoFormScreen(),
        ),
        GoRoute(path: 'cores', builder: (context, state) => CoresScreen()),
      ],
    ),
  ],
  errorBuilder:
      (context, state) => Scaffold(
        body: Center(
          child: Text(
            'Página não encontrada: ${state.matchedLocation}',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
);
