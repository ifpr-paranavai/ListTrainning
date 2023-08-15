import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:list_training/src/view/pages/check_page.dart';
<<<<<<< HEAD
import 'package:list_training/src/view/pages/pages_personal/details/personal_detail.dart';
=======
>>>>>>> 920acd94ca407e4c3b3f967d7b5c29424b0f3816

/// Flutter code sample for [BottomNavigationBar].

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  final _firebaseAuth = FirebaseAuth.instance;
  int _selectedIndex = 0;
<<<<<<< HEAD

  static final List<Widget> _pages = <Widget>[
    PersonalDetail(),
=======
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    Container(),
>>>>>>> 920acd94ca407e4c3b3f967d7b5c29424b0f3816
    Container(),
    Container(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void logout() async {
    await _firebaseAuth.signOut().then((user) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CheckPage(),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
<<<<<<< HEAD
        title: const Text('Start Trainining'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
=======
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Nome'),
              accountEmail: Text('Emial'),
            ),
            ListTile(
              dense: true,
              title: Text('Sair'),
              trailing: Icon(Icons.exit_to_app),
              onTap: logout,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
>>>>>>> 920acd94ca407e4c3b3f967d7b5c29424b0f3816
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
<<<<<<< HEAD
            label: 'Treinos',
=======
            label: 'Home',
>>>>>>> 920acd94ca407e4c3b3f967d7b5c29424b0f3816
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}
