import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/anuncio.dart';
import 'package:olx/util/configuracoes.dart';
import 'package:olx/views/widgets/item_anuncio.dart';

class Anuncios extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnunciosState();
  }
}

class AnunciosState extends State<Anuncios> {
  FirebaseAuth auth = FirebaseAuth.instance;

  List<String> itensMenu = [];

  String _itemSelecionadoEstado;
  String _itemSelecionadoCategoria;
  List<DropdownMenuItem<String>> _listaItensDropCategorias;
  List<DropdownMenuItem<String>> _listaItensDropEstados;

  final _controller = StreamController<QuerySnapshot>.broadcast();

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
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

  _deslogarUsuario() async {
    await auth.signOut();
    Navigator.pushNamed(context, '/login');
  }

  Future _verificaUsuarioLogado() async {
    User usuarioLogado = await auth.currentUser;

    if (usuarioLogado == null) {
      itensMenu = ['Entrar / Cadastrar'];
    } else {
      itensMenu = ['Meus anúncios', 'Deslogar'];
    }
  }

  void _carregarItensDropdown() {
    //CATEGORIAS

    _listaItensDropCategorias = Configuracoes.getCategorias();

    //ESTADOS

    _listaItensDropEstados = Configuracoes.getEstados();
  }

  Future<Stream<QuerySnapshot>> _adicionarListnerAnuncio() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db.collection('anuncios').snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();

    _carregarItensDropdown();

    _verificaUsuarioLogado();

    _adicionarListnerAnuncio();
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
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: Color(0xff9c27b0),
                        hint: const Text('Região',
                            style: TextStyle(color: Color(0xff9c27b0))),
                        style: TextStyle(fontSize: 22, color: Colors.black),
                        value: _itemSelecionadoEstado,
                        items: _listaItensDropEstados,
                        onChanged: (estado) {
                          setState(() {
                            _itemSelecionadoEstado = estado;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  width: 2,
                  height: 50,
                ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: Color(0xff9c27b0),
                        hint: const Text('Categorias',
                            style: TextStyle(color: Color(0xff9c27b0))),
                        style: TextStyle(fontSize: 22, color: Colors.black),
                        value: _itemSelecionadoCategoria,
                        items: _listaItensDropCategorias,
                        onChanged: (categoria) {
                          setState(() {
                            _itemSelecionadoCategoria = categoria;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                  case ConnectionState.done:
                    QuerySnapshot querySnapshot = snapshot.data;

                    if (querySnapshot.docs.length == 0) {
                      return Container(
                        padding: EdgeInsets.all(25),
                        child: Text(
                          'Nenhum anuncio! :(',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                          itemCount: querySnapshot.docs.length,
                          itemBuilder: (_, indice) {
                            List<DocumentSnapshot> anuncios =
                                querySnapshot.docs.toList();
                            DocumentSnapshot documentSnapshot =
                                anuncios[indice];
                            Anuncio anuncio = Anuncio.fromDocumentSnapshot(
                                documentSnapshot);

                            return ItemAnuncio(
                              anuncio: anuncio,
                              onTapItem: () {},
                            );
                          }),
                    );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
