import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/views/widgets/item_anuncio.dart';

class MeusAnuncios extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MeusAnunciosState();
  }
}

class MeusAnunciosState extends State<MeusAnuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();

  String _idUsuarioLogado;

  _recuperarDadosUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;

    ///recupera id do ususario logado
    _idUsuarioLogado = usuarioLogado.uid;
  }

  Future<Stream<QuerySnapshot>> _adicionarlistenerAnuncio() async {
    await _recuperarDadosUsuarioLogado();

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection('meus_anuncios')
        .doc(_idUsuarioLogado)
        .collection('anuncios')
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _removerAnuncio(String idAnuncio) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection('meus_anuncios')
        .doc(_idUsuarioLogado)
        .collection('anuncios')
        .doc(idAnuncio)
        .delete();
  }

  @override
  void initState() {
    super.initState();
    _adicionarlistenerAnuncio();
  }

  @override
  Widget build(BuildContext context) {
    var carregandoDados = Center(
      child: Column(
        children: [
          Text('Carregando Anuncios'),
          CircularProgressIndicator(),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Anuncios'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/novo-anuncio');
        },
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados;
              break;
            case ConnectionState.active:
            case ConnectionState.done:
            //exibir msg de erro
              if (snapshot.hasError) return Text('Erro ao carregar Dados');

              QuerySnapshot querySnapshot = snapshot.data;

              return ListView.builder(
                itemCount: querySnapshot.docs.length,
                itemBuilder: (_, indice) {
                  List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                  DocumentSnapshot documentSnapshot = anuncios[indice];
                  Anuncio anuncio =
                  Anuncio.fromDocumentSnapshot(documentSnapshot);

                  return ItemAnuncio(
                    anuncio: anuncio,
                    onPressedRemover: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirmar'),
                            content:
                            Text('Deseja realmente excluir o anuncio?'),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),

                              FlatButton(
                                onPressed: () {
                                  _removerAnuncio(anuncio.id);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Remover',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
          }
          return Container();
        },
      ),
    );
  }
}
