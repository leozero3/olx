import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCustom extends StatelessWidget {

  final TextEditingController controller;

  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextInputType type;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final String Function(String) validator;

  const InputCustom(
      {@required this.controller,
        @required this.hint,
        this.obscure = false,
        this.autofocus = false,
        this.type = TextInputType.text,
        this.inputFormatters,
        this.maxLines,
        this.validator

      });


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: type,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
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
