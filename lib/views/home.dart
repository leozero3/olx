import 'package:flutter/material.dart';
import 'package:olx/views/input_custom.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controllerEmail =
      TextEditingController(text: 'leo@leo.com');
  TextEditingController _controllerSenha =
      TextEditingController(text: 'leoleo');

  bool _cadastrar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 150,
                ),
              ),
              InputCustom(
                controller: _controllerEmail,
                hint: 'Email',
                autofocus: true,
                type: TextInputType.emailAddress,
              ),
              InputCustom(
                controller: _controllerSenha,
                hint: 'Senha',
                obscure: true,
                type: TextInputType.text,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Logar'),
                  Switch(
                    value: _cadastrar,
                    onChanged: (bool valor) {
                      setState(() {
                        _cadastrar = valor;
                      });
                    },
                  ),
                  const Text('Cadastrar'),
                ],
              ),
              RaisedButton(
                color: const Color(0xff9c27b0),
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                onPressed: () {},
                child: const Text(
                  'Entrar',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
