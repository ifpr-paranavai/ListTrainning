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
<<<<<<< HEAD
        width: MediaQuery.of(context).size.width / 1.2,
=======
>>>>>>> 920acd94ca407e4c3b3f967d7b5c29424b0f3816
        child: ElevatedButton.icon(
          onPressed: acao,
          icon: icone,
          label: Text(
            rotulo,
            style: const TextStyle(fontSize: 25),
          ),
          style: ElevatedButton.styleFrom(primary: cor, shape: borda),
        ),
      ),
    );
  }
}
