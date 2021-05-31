import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/views/widgets/botao_custom.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NovoAnuncioState();
  }
}

class NovoAnuncioState extends State<NovoAnuncio> {
  final List<File> _listaimagem = [];
  final ImagePicker _picker = ImagePicker();
  File imagemSelecionada;

  final _formKey = GlobalKey<FormState>();

  String _itemSelecionadoEstado;
  String _itemSelecionadoCategoria;

  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];

  Future _selecionarImagemGaleria() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    imagemSelecionada = File(pickedFile.path);

    if (imagemSelecionada != null) {
      setState(() {
        _listaimagem.add(imagemSelecionada);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
  }

  void _carregarItensDropdown() {

    for(var estado in Estados.listaEstadosSigla){
      _listaItensDropEstados.add(
        DropdownMenuItem( value: estado,child: Text(estado),)
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Anuncio'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                imagensFormField(),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoEstado,
                          hint: Text('Estados'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          items: _listaItensDropEstados,
                          validator: (valor){
                            return Validador().add(v)
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoEstado = valor.toString();
                            });

                          },

                        ),
                      ),
                    ),
                    Text('Categoria'),
                  ],
                ),
                Text('Caixas de Textos'),
                BotaoCustom(
                  texto: 'Cadastrar Anuncio',
                  onPressed: () {
                    if (_formKey.currentState.validate()) {}
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FormField<List> imagensFormField() {
    return FormField<List>(
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
                              Text(
                                'Adicionar',
                                style: TextStyle(),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  if (_listaimagem.length > 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.file(_listaimagem[indice]),
                                  TextButton(
                                    child: Text('Excluir'),
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red)),
                                    onPressed: () {
                                      setState(() {
                                        _listaimagem.removeAt(indice);
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(_listaimagem[indice]),
                          child: Container(
                            color: Color.fromRGBO(255, 255, 255, 0.4),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
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
    );
  }
}
