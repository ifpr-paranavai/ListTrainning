import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ButtonEntrar extends StatelessWidget {
  ButtonEntrar(
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
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 50,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfff45d27),
              Color(0xFFf5851f),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: SizedBox.expand(
        child: TextButton(
          onPressed: acao,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                rotulo,
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
