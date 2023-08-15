import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:list_training/firebase_options.dart';
import 'package:list_training/src/view/pages/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
<<<<<<< HEAD


=======
>>>>>>> 920acd94ca407e4c3b3f967d7b5c29424b0f3816
