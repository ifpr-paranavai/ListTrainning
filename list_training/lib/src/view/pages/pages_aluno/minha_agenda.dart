import 'package:flutter/material.dart';
import 'package:list_training/src/view/components/drawer.dart';

class MinhaAgenda extends StatefulWidget {
  const MinhaAgenda({super.key});

  @override
  State<MinhaAgenda> createState() => _MinhaAgendaState();
}

class _MinhaAgendaState extends State<MinhaAgenda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrawerExample(),
      body: ListView(),
    );
  }
}
