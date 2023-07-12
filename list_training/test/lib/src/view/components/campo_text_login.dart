import 'package:flutter/material.dart';

class CampoTextoLogin extends StatelessWidget {
  String rotulo;
  late TextEditingController controller;
  Icon icone;
  TextInputType tipo;
  String? retornoValidador;
  bool visibilidade = false;

  CampoTextoLogin(
      {Key? key,
      required this.icone,
      required this.visibilidade,
      required this.rotulo,
      required this.tipo,
      required this.controller,
      required this.retornoValidador})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 1.2,
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 4,
        right: 16,
        left: 16,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
            ),
          ]),
      child: TextFormField(
        keyboardType: tipo,
        controller: controller,
        decoration: InputDecoration(
          icon: icone,
          hintText: rotulo,
        ),
        obscureText: visibilidade,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return retornoValidador;
          }
        },
      ),
    );
  }
}
