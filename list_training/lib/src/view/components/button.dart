import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button(
      {Key? key,
      required this.icone,
      required this.rotulo,
      required this.cor,
      required this.borda,
      required this.acao})
      : super(key: key);

  Icon icone;
  String rotulo;
  Color cor;
  OutlinedBorder borda;
  VoidCallback acao;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: ElevatedButton.icon(
          onPressed: acao,
          icon: icone,
          label: Text(
            rotulo,
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(primary: cor, shape: borda),
        ),
      ),
    );
  }
}
