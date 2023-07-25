import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nossa_lista_de_compras/custom_notification.dart';
import 'package:provider/provider.dart';
import '../lista_de_compras.dart';
import 'lista_de_compras_page.dart';

import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase _database = FirebaseDatabase.instance;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  //TODO: O armazenamento das listas deve ser feito em nuvem
  List<ListaDeCompras> listListaDeCompras = [];

  final txtControlerNomeLista = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: buscarListasDoUsuario(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Erro ao buscar as listas: ${snapshot.error}');
                  } else {
                    return listListaDeCompras.isEmpty
                      ? const Text('Você ainda não criou nenhuma lista de compras')
                      : showListasDeComprasGrid(listListaDeCompras);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNovaListaDeComprasDialog,
        tooltip: 'Adicionar nova lista de compras',
        child: const Icon(Icons.add),
      ),
    );
  }

  void addNovaListaDeCompras() {
    ListaDeCompras novaLista = ListaDeCompras(
      txtControlerNomeLista.text,
    );
    novaLista.membros.add(user.email.toString());
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

  void showNovaListaDeComprasDialog() {
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
                      if (value != null) {
                        return value.isNotEmpty ? null : "Enter any text";
                      } else {
                        return "Enter any text";
                      }
                    },
                    decoration: const InputDecoration(
                        hintText: "Nome da Lista"),
                  ),
                ],
              )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () =>
              {
                addNovaListaDeCompras(),
                Navigator.pop(context)
              },
              child: const Text('Adicionar Lista'),
            ),
          ],
        );
      },
    );
  }

  Widget showListasDeComprasGrid(List<ListaDeCompras> listListaDeCompras) {
    return GridView.count(
        crossAxisCount: 3,
        children: List.generate(listListaDeCompras.length, (index) {
          return CardItem(listaDeCompras: listListaDeCompras[index]);
        })
    );
  }

  Future<void> buscarListasDoUsuario() async {
    String email = user.email.toString();
    DatabaseReference listaRef = FirebaseDatabase.instance.ref().child('listas_de_compras');

    // Faz a consulta para buscar as listas onde o usuário está incluído como membro
    DatabaseEvent dbSnapshot = await listaRef.once();

    // Limpa a lista antes de preenchê-la com os novos dados
    listListaDeCompras.clear();

    // Verifica se o snapshot tem algum valor
    if (dbSnapshot.snapshot.value != null) {
      // Converte o valor para o tipo correto (Map<String, dynamic>?)
      Map<String, dynamic>? dataMap = dbSnapshot.snapshot.value as Map<String, dynamic>?;

      // Itera sobre cada par chave/valor no mapa
      dataMap?.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          // Verifica se o usuário está incluído como membro
          List<dynamic> membros = value['membros'];
          if (membros.contains(email)) {
            List<Item> itens = [];
            // Cria uma instância de ListaDeCompras diretamente a partir do mapa de dados da lista
            if(value['itens'] != null){
                itens = (value['itens'] as List<dynamic>).map((item) {
                return Item(
                  item['nome'],
                  item['quantidade'],
                  UnidadeDeMedida.values[item['unidade']], // Recuperar o enum usando o índice numérico
                  item['status'],
                );
              }).toList();
            }

            ListaDeCompras lista = ListaDeCompras(
              value['nome'],
              itens: itens,
              membros: membros.cast<String>(),
            );

            listListaDeCompras.add(lista);
          }
        }
      });
    }
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
    DatabaseReference listaRef = _database.ref().child('listas_de_compras');
    await listaRef.push().set({
      'nome': listaDeCompras.nome,
      'itens': [],
      'membros': listaDeCompras.membros,
    });
  } catch (e) {
    print('Erro ao salvar a lista de compras: $e');
  }
}