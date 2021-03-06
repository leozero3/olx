import 'package:flutter/material.dart';

class BotaoCustom extends StatelessWidget {
  final String texto;
  final Color corTexto;
  final VoidCallback onPressed;

  const BotaoCustom(
      {@required this.texto, this.corTexto = Colors.white, this.onPressed});

  @override
  Widget build(BuildContext context) {


    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      textColor: corTexto,
      color: Color(0xff9c27b0),
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      onPressed: onPressed,

      child: Text(
        texto,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
