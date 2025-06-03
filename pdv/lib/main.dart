import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdv/services/auth_service.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  await authService.loadToken();

  runApp(MyApp(authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp(this.authService, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>.value(
      value: authService,
      child: MaterialApp.router(
        routerConfig: goRouter,
        title: 'PDV App',
        theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
