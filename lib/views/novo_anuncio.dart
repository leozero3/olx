import 'package:flutter/material.dart';
import 'package:olx/views/widgets/botao_custom.dart';

class NovoAnuncio extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NovoAnuncioState();
  }
  
}
class NovoAnuncioState extends State<NovoAnuncio>{

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Anuncio'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //FormField(),

                Row(
                  children: [
                    Text('Estado'),
                    Text('Categoria'),
                  ],
                ),
                Text('Caixas de Textos'),
                BotaoCustom(
                  texto: 'Cadastrar Anuncio',
                  onPressed: () {
                    if(_formKey.currentState.validate());
                  },
                ),

              ],
            ),
          ),


        ),
      ),
    );
  }
  
}