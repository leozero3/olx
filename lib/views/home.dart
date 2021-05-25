import 'package:flutter/material.dart';
import 'package:olx/models/usuario.dart';
import 'package:olx/views/input_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controllerEmail =
      TextEditingController(text: 'leo@leo.com');
  final TextEditingController _controllerSenha =
      TextEditingController(text: 'leoleo');

  bool _cadastrar = false;
  String _mensagemErro = '';
  String _textoBotao = 'Entrar';

  FirebaseAuth auth = FirebaseAuth.instance;

  _cadastrarUsuario(Usuario usuario){

    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha,
    ).then((firebaseUser) {



    });
  }

  _logarUsuario(Usuario usuario){

    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha,
    ).then((firebaseUser){

    });
  }


  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;


    if (email.isNotEmpty && email.contains('@')) {
      if (senha.isNotEmpty && senha.length >= 6) {

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        if(_cadastrar){

          _cadastrarUsuario(usuario);

        }else{

          _logarUsuario(usuario);
        }


      } else {
        setState(() {
          _mensagemErro = 'Minimo de 6 caracteres';
        });
      }
    } else {
      setState(() {
        _mensagemErro = 'Preecha o E-mail válido';
      });
    }
  }

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
                        _textoBotao = 'Entrar';
                        if (_cadastrar) {
                          _textoBotao = 'Cadastrar';
                          
                        }  
                      });
                    },
                  ),
                  const Text('Cadastrar'),
                ],
              ),
              RaisedButton(
                color: const Color(0xff9c27b0),
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                onPressed: () {
                  _validarCampos();
                },
                child: Text(
                  _textoBotao,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _mensagemErro,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
