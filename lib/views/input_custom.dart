import 'package:flutter/material.dart';

class InputCustom extends StatelessWidget {

  final TextEditingController controller;

  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextInputType type;

  const InputCustom(
      {@required this.controller,
        @required this.hint,
        this.obscure = false,
        this.autofocus = false,
        this.type = TextInputType.text});


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: type,
      autofocus: autofocus,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
