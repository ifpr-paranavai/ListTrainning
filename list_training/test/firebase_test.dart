import 'package:flutter/material.dart';

void main() {
<<<<<<< HEAD
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

=======
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
>>>>>>> 920acd94ca407e4c3b3f967d7b5c29424b0f3816
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
      ),
    );
  }
}
