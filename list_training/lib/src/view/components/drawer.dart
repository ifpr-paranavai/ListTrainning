import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:list_training/src/view/pages/check_page.dart';

class DrawerExample extends StatelessWidget {
  const DrawerExample({super.key});

  @override
  Widget build(BuildContext context) {
    final _firebaseAuth = FirebaseAuth.instance;
    void logout() async {
      await _firebaseAuth.signOut().then((user) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CheckPage(),
            ),
          ));
    }

    return Drawer(
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Container(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                    onPressed: () {
                      logout();
                    },
                    child: Text('Sair')),
              )
            ]),
      ),
    );
  }
}
