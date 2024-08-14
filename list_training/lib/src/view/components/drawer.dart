import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:list_training/src/view/pages/check_page.dart';
import 'package:list_training/src/view/pages/pages_exercicio/exercicio_detail.dart';
import 'package:list_training/src/view/pages/pages_grupo_muscular/gupo_muscular_detail.dart';

class DrawerExample extends StatefulWidget {
  const DrawerExample({super.key});

  @override
  State<DrawerExample> createState() => _DrawerExampleState();
}

class _DrawerExampleState extends State<DrawerExample> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Future<void> _getUserData() async {
    final user = _auth.currentUser;
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    void logout() async {
      await firebaseAuth.signOut().then((user) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CheckPage(),
            ),
          ));
    }

    return Drawer(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                        'Nome de Usuário: ${_user!.displayName ?? 'Não disponível'}'),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExercicioDetail(),
                    ),
                  );
                },
                child: const Text('Exercicios'),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GrupoMuscularDetail(),
                    ),
                  );
                },
                child: const Text('Grupo Muscular'),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  logout();
                },
                child: const Text('Sair'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
