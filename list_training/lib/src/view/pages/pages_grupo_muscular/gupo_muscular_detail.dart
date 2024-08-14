import 'package:flutter/material.dart';
import 'package:list_training/src/model/firebase/grupo_muscular_firebase.dart';

class GrupoMuscularDetail extends StatefulWidget {
  const GrupoMuscularDetail({super.key});

  @override
  State<GrupoMuscularDetail> createState() => _GrupoMuscularDetailState();
}

class _GrupoMuscularDetailState extends State<GrupoMuscularDetail> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  GrupoMuscularFirebase grupoMuscularFirebase = GrupoMuscularFirebase();
  String retornoValidador = 'Campo obrigatório';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ListTraining'),
      ),
    );
  }
}
