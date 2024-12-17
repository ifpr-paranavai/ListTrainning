import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:list_training/src/view/pages/check_page.dart';
import 'package:list_training/src/view/pages/home_page.dart';
import 'package:list_training/src/view/pages/pages_exercicio/exercicio_detail.dart';
import 'package:list_training/src/view/pages/pages_grupo_muscular/gupo_muscular_detail.dart';
import 'package:list_training/src/view/pages/pages_treino/treino_detail.dart';

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
      child: Column(
        children: [
          // Cabeçalho do Drawer com informações do usuário
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
            accountName: Text(
              _user?.displayName ?? 'Usuário Anônimo',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(
              _user?.email ?? 'Email não disponível',
              style: const TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _user?.displayName?.substring(0, 1).toUpperCase() ?? '?',
                style: const TextStyle(fontSize: 40, color: Colors.deepPurple),
              ),
            ),
          ),

          // Lista de opções no Drawer
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.deepPurple),
                  title: const Text(
                    'Home',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.fitness_center,
                      color: Colors.deepPurple),
                  title: const Text(
                    'Treinos',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TreinoDetail(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.directions_run,
                      color: Colors.deepPurple),
                  title: const Text(
                    'Exercícios',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExercicioDetail(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.group_work, color: Colors.deepPurple),
                  title: const Text(
                    'Grupo Muscular',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GrupoMuscularDetail(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Botão de Logout
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              label: const Text(
                'Sair',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: () {
                logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
