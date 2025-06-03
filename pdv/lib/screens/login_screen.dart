import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdv/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(
    text: "joao.silva@example.com",
  );
  final _passwordController = TextEditingController(text: "123456");
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    final success = await auth.login(
      _emailController.text,
      _passwordController.text,
    );
    setState(() => _loading = false);
    if (success) {
      context.go('/dashboard'); // <- Redirecionamento com go_router
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login falhou!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: Text("Entrar")),
            TextButton(
              onPressed: () {
                // pode futuramente usar `context.go('/register')`
              },
              child: Text("Não tem conta? Cadastre-se"),
            ),
          ],
        ),
      ),
    );
  }
}
