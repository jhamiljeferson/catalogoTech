import 'package:flutter/material.dart';
import 'package:pdv/screens/dashboard_screen.dart';
import 'package:pdv/screens/login_screen.dart';
import 'package:pdv/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService()..loadToken(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDV App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/':
            (context) => Consumer<AuthService>(
              builder: (context, auth, _) {
                return auth.token == null ? LoginScreen() : DashboardScreen();
              },
            ),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        // Adicione outras rotas conforme necessário
      },
    );
  }
}
