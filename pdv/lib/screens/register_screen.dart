import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cargoIdController = TextEditingController();
  final _roleController = TextEditingController();
  bool _loading = false;

  Future<void> _register() async {
    setState(() => _loading = true);
    final auth = Provider.of<AuthService>(context, listen: false);

    // Converte os valores do texto para os tipos corretos (int para cargoId e String para role)
    int cargoId = int.tryParse(_cargoIdController.text) ?? 1; // Valor padrão 1
    String role =
        _roleController.text.isNotEmpty
            ? _roleController.text
            : "USER"; // Valor padrão "USER"

    bool success = await auth.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
      cargoId,
      role,
    );

    setState(() => _loading = false);

    if (success) {
      Navigator.pop(
        context,
      ); // Retorna à tela de login ou navega para outra tela
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Cadastro falhou!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            TextField(
              controller: _cargoIdController,
              decoration: InputDecoration(labelText: "Cargo ID (número)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: "Role (ex: USER, ADMIN)"),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _register,
                  child: Text("Cadastrar"),
                ),
          ],
        ),
      ),
    );
  }
}
