import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:list_training/src/view/components/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: DrawerExample(),
        body: Container(),
      ),
    );
  }
}
