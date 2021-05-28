import 'dart:io';

import 'package:flutter/material.dart';
import 'package:olx/views/widgets/botao_custom.dart';

class NovoAnuncio extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NovoAnuncioState();
  }
}

class NovoAnuncioState extends State<NovoAnuncio> {
  List<File> _listaimagem = [];

  final _formKey = GlobalKey<FormState>();

  _selecionarImagemGaleria() {}

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
                FormField<List>(
                  initialValue: _listaimagem,
                  validator: (imagens) {
                    if (imagens.length == 0) {
                      return 'Necessario selecionar uma Imagem!';
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _listaimagem.length + 1,
                            itemBuilder: (context, indice) {
                              if (indice == _listaimagem.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      _selecionarImagemGaleria();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: Colors.grey[100],
                                          ),
                                          Text('Adicionar', style: TextStyle(),)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (_listaimagem.length > 0) {}
                              return Container();
                            },
                          ),
                        ),
                        if (state.hasError)
                          Container(
                            child: Text(
                              '[${state.errorText}]',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
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
                    if (_formKey.currentState.validate()) ;
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
