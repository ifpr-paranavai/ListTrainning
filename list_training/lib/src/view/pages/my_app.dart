import 'package:flutter/material.dart';
import 'package:list_training/src/view/pages/check_page.dart';
import 'package:list_training/src/view/pages/login_page.dart';
import 'package:list_training/src/view/pages/pages_treino/treino_detail.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListTraining',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      initialRoute: '/', // Define a rota inicial
      routes: {
        '/': (context) => const CheckPage(), // Verifica login
        '/home': (context) => const TreinoDetail(), // Página principal
        '/login': (context) => const LoginPage(), // Página de login
      },
    );
  }
}
