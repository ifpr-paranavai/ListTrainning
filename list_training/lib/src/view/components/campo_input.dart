import 'package:flutter/material.dart';

class CampoInput extends StatelessWidget {
  String rotulo;
  TextInputType tipo;
  TextEditingController controller;
  String? retornoValidador;
  bool visibilidade = false;

  CampoInput(
      {Key? key,
      required this.visibilidade,
      required this.rotulo,
      required this.tipo,
      required this.controller,
      required this.retornoValidador})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300,
        child: TextFormField(
          keyboardType: tipo,
          controller: controller,
          decoration: InputDecoration(
              label: Text(rotulo),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          obscureText: visibilidade,
<<<<<<< HEAD
          validator: (value) {
=======
          validator: (String? value) {
>>>>>>> 920acd94ca407e4c3b3f967d7b5c29424b0f3816
            if (value == null || value.isEmpty) {
              return retornoValidador;
            }
          },
        ),
      ),
    );
  }
}
