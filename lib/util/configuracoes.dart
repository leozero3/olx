import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Configuracoes{


  //Estados
  static List<DropdownMenuItem<String>> getEstados(){

    List<DropdownMenuItem<String>> listaItensDropEstados = [];

    listaItensDropEstados.add(const DropdownMenuItem(
        value: null,
        child: Text('Região', style: TextStyle(color: Color(0xff9c27b0)))));

    for (final estado in Estados.listaEstadosSigla) {
      listaItensDropEstados.add(DropdownMenuItem(
        value: estado,
        child: Text(estado),
      ));
    }

    return listaItensDropEstados;

  }


  //Categorias
  static List<DropdownMenuItem<String>> getCategorias(){

    List<DropdownMenuItem<String>> itensDropCategorias = [];



    itensDropCategorias.add(const DropdownMenuItem(
        value: null,
        child: Text('Categoria', style: TextStyle(color: Color(0xff9c27b0)))));
    itensDropCategorias.add(const DropdownMenuItem(value: 'auto', child: Text('Automovel')));
    itensDropCategorias.add(const DropdownMenuItem(value: 'imovel', child: Text('Imovel')));
    itensDropCategorias.add(const DropdownMenuItem(value: 'moda', child: Text('Moda')));
    itensDropCategorias.add(const DropdownMenuItem(value: 'esportes', child: Text('Esportes')));
    itensDropCategorias.add(const DropdownMenuItem(value: 'eletro', child: Text('Eletro')));
    itensDropCategorias.add(const DropdownMenuItem(value: 'informaica', child: Text('Informaica')));

    return itensDropCategorias;

  }
}