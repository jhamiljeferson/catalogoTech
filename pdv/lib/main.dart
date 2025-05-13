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
      home: Consumer<AuthService>(
        builder: (context, auth, _) {
          return auth.token == null ? LoginScreen() : DashboardScreen();
        },
      ),
    );
  }
}
