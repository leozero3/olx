import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/views/widgets/botao_custom.dart';
import 'package:olx/views/widgets/input_custom.dart';
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

  Anuncio _anuncio;
  BuildContext _dialogContext;

  final _formKey = GlobalKey<FormState>();

  String _itemSelecionadoEstado;
  String _itemSelecionadoCategoria;

  final List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  final List<DropdownMenuItem<String>> _listaItensDropCategorias = [];

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
    _anuncio = Anuncio.gerarId();
  }

  void _carregarItensDropdown() {
    _listaItensDropCategorias.add(const DropdownMenuItem(value: 'auto', child: Text('Automovel')));
    _listaItensDropCategorias.add(const DropdownMenuItem(value: 'imovel', child: Text('Imovel')));
    _listaItensDropCategorias.add(const DropdownMenuItem(value: 'moda', child: Text('Moda')));
    _listaItensDropCategorias
        .add(const DropdownMenuItem(value: 'esportes', child: Text('Esportes')));
    _listaItensDropCategorias.add(const DropdownMenuItem(value: 'eletro', child: Text('Eletro')));
    _listaItensDropCategorias
        .add(const DropdownMenuItem(value: 'informaica', child: Text('Informaica')));

    for (final estado in Estados.listaEstadosSigla) {
      _listaItensDropEstados.add(DropdownMenuItem(
        value: estado,
        child: Text(estado),
      ));
    }
  }

  _abrirDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false, // bloqueio de tela
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Salvando Anuncio...')
              ],
            ),
          );
        });
  }

  _salvarAnuncio() async {
    _abrirDialog(_dialogContext);

    //upload imagens
    await _uploadimagens();
    print('lista de imagens::::: ${_anuncio.fotos.toString()}');

    //salvar anuncio
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;  ///recupera id do ususario logado
    String idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('meus_anuncios')
        .doc(idUsuarioLogado)
        .collection('anuncios')
        .doc(_anuncio.id)
        .set(_anuncio.toMap())
        .then((_) {

          db.collection('anuncios')
          .doc(_anuncio.id)
          .set(_anuncio.toMap()). then((_) {

            Navigator.pop(_dialogContext); //fecha o dialogContext
            Navigator.pop(context);
          });



    });
  }

  Future _uploadimagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();

    for (var imagem in _listaimagem) {
      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      Reference arquivo = pastaRaiz.child('meus_anuncios').child(_anuncio.id).child(nomeImagem);

      UploadTask uploadTask = arquivo.putFile(imagem);
      TaskSnapshot taskSnapshot = await uploadTask;
      // uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      //   try {
      //     await uploadTask;
      //     print('Upload complete.');
      //   } on FirebaseException catch (e) {
      //     if (e.code == 'permission-denied') {
      //       print('User does not have permission to upload to this reference.');
      //     }
      //   }
      // });

      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio.fotos.add(url);
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
                dropDown(),
                tituloAnuncio(),
                precoAnuncio(),
                telefoneAnuncio(),
                descricaoAnuncio(),
                BotaoCustom(
                  texto: 'Cadastrar Anuncio',
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //salvar campos
                      _formKey.currentState.save();

                      //configura dialogcontext
                      _dialogContext = context;

                      //salva anuncio
                      _salvarAnuncio();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding tituloAnuncio() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 15),
      child: InputCustom(
        hint: 'Titulo',
        onSaved: (titulo) {
          _anuncio.titulo = titulo;
        },
        validator: (valor) {
          return Validador().add(Validar.OBRIGATORIO, msg: 'Campo obrigatório').valido(valor);
        },
      ),
    );
  }

  Padding precoAnuncio() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 15),
      child: InputCustom(
        hint: 'Preço',
        onSaved: (preco) {
          _anuncio.preco = preco;
        },
        type: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          RealInputFormatter(centavos: true),
        ],
        validator: (valor) {
          return Validador().add(Validar.OBRIGATORIO, msg: 'Campo obrigatório').valido(valor);
        },
      ),
    );
  }

  Padding telefoneAnuncio() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 15),
      child: InputCustom(
        hint: 'Telefone',
        onSaved: (telefone) {
          _anuncio.telefone = telefone;
        },
        type: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly, TelefoneInputFormatter()],
        validator: (valor) {
          return Validador().add(Validar.OBRIGATORIO, msg: 'Campo obrigatório').valido(valor);
        },
      ),
    );
  }

  Padding descricaoAnuncio() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 15),
      child: InputCustom(
        hint: 'Descrição',
        maxLines: null,
        onSaved: (descricao) {
          _anuncio.descricao = descricao;
        },
        validator: (valor) {
          return Validador()
              .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
              .maxLength(200, msg: 'Máximo de 200 caracteres')
              .valido(valor);
        },
      ),
    );
  }

  Row dropDown() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              value: _itemSelecionadoEstado,
              hint: const Text('Estados'),
              onSaved: (estado) {
                _anuncio.estado = estado;
              },
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              items: _listaItensDropEstados,
              validator: (valor) {
                return Validador().add(Validar.OBRIGATORIO, msg: 'Campo obrigatório').valido(valor);
              },
              onChanged: (valor) {
                setState(() {
                  _itemSelecionadoEstado = valor;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              value: _itemSelecionadoCategoria,
              hint: const Text('Categoria'),
              onSaved: (categoria) {
                _anuncio.categoria = categoria;
              },
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              items: _listaItensDropCategorias,
              validator: (valor) {
                return Validador().add(Validar.OBRIGATORIO, msg: 'Campo obrigatório').valido(valor);
              },
              onChanged: (valor) {
                setState(() {
                  _itemSelecionadoCategoria = valor;
                });
              },
            ),
          ),
        ),
      ],
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
                      padding: const EdgeInsets.symmetric(
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
                              const Text(
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
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(Colors.red)),
                                    onPressed: () {
                                      setState(() {
                                        _listaimagem.removeAt(indice);
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text('Excluir'),
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
                            color: const Color.fromRGBO(255, 255, 255, 0.4),
                            alignment: Alignment.center,
                            child: const Icon(
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
