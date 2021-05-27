import 'package:flutter/material.dart';

class MeusAnuncios extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MeusAnunciosState();
  }
  
}
class MeusAnunciosState extends State<MeusAnuncios>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Anuncios'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context, '/novo-anuncio');
        },
      ),
      body: Container(),
    );
  }
  
}