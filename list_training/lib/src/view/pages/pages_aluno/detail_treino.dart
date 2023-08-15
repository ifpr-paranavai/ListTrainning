import 'package:flutter/material.dart';
import 'package:list_training/src/model/entidades/treino.dart';

class DetailTreino extends StatefulWidget {
  const DetailTreino({super.key});

  @override
  State<DetailTreino> createState() => _DetailTreinoState();
}

class _DetailTreinoState extends State<DetailTreino> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Treino>>(
      builder: (context, snapshot) {
        return ListView();
      },
    );
  }
}
