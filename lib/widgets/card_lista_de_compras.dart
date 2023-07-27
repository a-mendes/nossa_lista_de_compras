import 'package:flutter/material.dart';
import 'package:nossa_lista_de_compras/lista_de_compras.dart';
import 'package:nossa_lista_de_compras/pages/lista_de_compras_page.dart';

class CardListaDeCompra extends StatelessWidget {
  const CardListaDeCompra({
  super.key,
  required this.listaDeCompras
  });

  final ListaDeCompras listaDeCompras;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(
                          'https://i.pinimg.com/originals/4a/38/7b/4a387bda853bca3782d73234c786a150.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Text(
                        listaDeCompras.getName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            'Membros',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
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