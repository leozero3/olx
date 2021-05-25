import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Anuncios extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnunciosState();
  }

}

class AnunciosState extends State<Anuncios> {

  FirebaseAuth auth = FirebaseAuth.instance;

  List<String> itensMenu = [];

  _escolhaMenuItem(String itemEscolhido){

    switch(itemEscolhido){
      case 'Meus anúncios':
        Navigator.pushNamed(context, '/meus-anuncios');
        break;
      case 'Entrar / Cadastrar':
        Navigator.pushNamed(context, '/login');
        break;
      case 'Deslogar':
        _deslogarUsuario();
        break;

    }

  }

  _deslogarUsuario()async{
    await auth.signOut();
    Navigator.pushNamed(context, '/login');
  }

  Future _verificaUsuarioLogado()async{

    User usuarioLogado = await auth.currentUser;

    if( usuarioLogado == null ){
      itensMenu = ['Entrar / Cadastrar'];
    }else{
      itensMenu = ['Meus anúncios', 'Deslogar'];
    }

  }
  @override
  void initState() {
    super.initState();

    _verificaUsuarioLogado();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OLX'),
        elevation: 0,
        actions: [
          PopupMenuButton(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                    child: Text(item),
                );

              }).toList();

            },),

        ],

      ),
      body: Container(
        child: Text('Anúncios'),
      ),
    );
  }

}