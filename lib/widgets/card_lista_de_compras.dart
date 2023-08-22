import 'package:flutter/material.dart';
import 'package:nossa_lista_de_compras/lista_de_compras.dart';
import 'package:nossa_lista_de_compras/pages/lista_de_compras_page.dart';

import '../card_customization.dart';

class CardListaDeCompra extends StatelessWidget {
  const CardListaDeCompra({
  super.key,
  required this.listaDeCompras
  });

  final ListaDeCompras listaDeCompras;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColorUtils.getColor(listaDeCompras.cor),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FormPage(listaDeCompras: listaDeCompras),
                ),
              );
            },
            child: Container(
              height: 290,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)
              ),
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.shopping_cart,
                          size: 32,
                        ),
                      ),
                      Text(
                        listaDeCompras.getName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        )
    );
  }
  actionButtonCard(){
    FormPage(listaDeCompras: listaDeCompras);
  }
}