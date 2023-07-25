import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nossa_lista_de_compras/custom_notification.dart';
import 'package:provider/provider.dart';
import '../lista_de_compras.dart';
import 'lista_de_compras_page.dart';

import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //TODO: O armazenamento das listas deve ser feito em nuvem
  List<ListaDeCompras> listListaDeCompras = [];
  final txtControlerNomeLista = TextEditingController();

  @override
  void dispose() {
    txtControlerNomeLista.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: !listListaDeCompras.isNotEmpty,
              child: const Text('Você ainda não criou nenhuma lista de compras'),
            ),
            Expanded(
              child: showListasDeComprasGrid(listListaDeCompras),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNovaListadeComprasDialog,
        tooltip: 'Adicionar nova lista de compras',
        child: const Icon(Icons.add),
      ),
    );
  }

  void addNovaListadeCompras() {
    ListaDeCompras novaLista = ListaDeCompras(
      txtControlerNomeLista.text,
    );
    salvarListaDeCompras(novaLista);
    setState(() {
      listListaDeCompras.add(novaLista);

      Provider.of<NotificationService>(context, listen: false).showNotification(
        CustomNotification(
          id: 1,
          title: 'Nova Lista de Compras!',
          body: 'Uma nova lista de compras foi criada. Acesse o app e confira!',
          payload: '/home'
        )
      );
    });
  }

  void showNovaListadeComprasDialog(){
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Nova lista de compras'),
          content: Form(
            //key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: txtControlerNomeLista,
                    validator: (value) {
                      if(value != null) {
                        return value.isNotEmpty ? null : "Enter any text";
                      } else {
                        return  "Enter any text";
                      }
                    },
                    decoration: const InputDecoration(hintText: "Nome da Lista"),
                  ),
                ],
              )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => {
                addNovaListadeCompras(),
                Navigator.pop(context)
              },
              child: const Text('Adicionar Lista'),
            ),
          ],
        );
      },
    );
  }

  Widget showListasDeComprasGrid(List<ListaDeCompras> listListaDeCompras){
    return GridView.count(
        crossAxisCount: 3,
        children: List.generate(listListaDeCompras.length, (index) {
          return Container(
            child: CardItem(listaDeCompras: listListaDeCompras[index]),
          );
        })
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({
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

Future<void> salvarListaDeCompras(ListaDeCompras listaDeCompras) async {
  try {
    final FirebaseDatabase _database = FirebaseDatabase.instance;
    DatabaseReference listaRef = _database.reference().child('listas_de_compras');
    await listaRef.push().set({
      'nome': listaDeCompras.nome,
      'itens': listaDeCompras.itens.map((item) => {
        'nome': item.nome,
        'quantidade': item.quantidade,
        'status': item.status,
      }).toList(),
      'membros': listaDeCompras.membros,
    });
    // Salvar bem-sucedido
  } catch (e) {
    // Ocorreu um erro durante o salvamento, trate-o de acordo
    print('Erro ao salvar a lista de compras: $e');
  }
}