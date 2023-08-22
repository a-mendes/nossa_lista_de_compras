import 'dart:ffi';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'card_customization.dart';

enum UnidadeDeMedida {
  u,  //Unidades
  kg, //Kilogramas
  g,  //Gramas
  l,  //Litros
  ml, //Mililitros
}

class ListaDeCompras {
  String nome;
  List<Item>? itens;
  List<String>? membros;
  CustomColor cor;
  var id = Random().nextInt(100000000);

  ListaDeCompras(this.nome, this.cor, {List<Item>? itens, List<String>? membros})
      : itens = itens ?? [],
        membros = membros ?? [];

  String get getName {
    return nome;
  }

  int addItem(String nomeItem, int qtde, UnidadeDeMedida unidade, String categoria){
    if(qtde <= 0) {
      return 0;
    }
    if(nomeItem.isEmpty){
      return 0;
    }

    print("categoria on add $categoria");
    itens?.add(Item(nomeItem, qtde, unidade, false, categoria));
    return 1;
  }
}

class Item{
  String nome;
  int quantidade;
  bool status;
  UnidadeDeMedida unidade;
  String categoria;

  Item(this.nome, this.quantidade, this.unidade, this.status, this.categoria);

  UnidadeDeMedida get getUnidade {
    return unidade;
  }
}