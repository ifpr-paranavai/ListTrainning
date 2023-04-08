import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:list_training/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'List-Training',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        alignment: Alignment.center,
        child: const Text("Hello word"),
      ),
    );
  }
}
