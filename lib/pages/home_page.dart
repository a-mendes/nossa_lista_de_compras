import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nossa_lista_de_compras/card_customization.dart';
import 'package:nossa_lista_de_compras/custom_notification.dart';
import 'package:nossa_lista_de_compras/custom_utils.dart';
import 'package:nossa_lista_de_compras/services/firebase_messaging_service.dart';
import 'package:nossa_lista_de_compras/services/notification_service.dart';
import 'package:nossa_lista_de_compras/widgets/card_lista_de_compras.dart';
import 'package:nossa_lista_de_compras/widgets/dropdownmenu_custom.dart';
import 'package:provider/provider.dart';
import '../lista_de_compras.dart';

import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase _database = FirebaseDatabase.instance;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<ListaDeCompras> listListaDeCompras = [];

  final txtControlerNomeLista = TextEditingController();

  /* Personalização Card Lista */
  CustomColor corLista =  CustomColor.white;

  @override
  void initState() {
    super.initState();
    initializeFirebaseMessaging();
    checkForNotifications();
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
                      ? const Center(child:Text('Você ainda não criou nenhuma lista de compras'))
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

  void addNovaListaDeCompras(/*Color cor, Icon icone*/) {
    ListaDeCompras novaLista = ListaDeCompras(
      txtControlerNomeLista.text,
      corLista,
      membros: [user.email.toString()],
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

                  DropdownMenuCustom<String>(
                      list: CustomColor.values.map((e) => e.toString().split('.').last).toList(),
                      doOnSelected: (String? cor) => {
                      corLista = CustomColor.values.firstWhere(
                            (status) => status.toString().split('.').last == cor,
                        orElse: () => CustomColor.pastelYellow),
                    }
                  )
                ],
              )
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => {
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
          return CardListaDeCompra(listaDeCompras: listListaDeCompras[index]);
        })
    );
  }

  Future<void> buscarListasDoUsuario() async {
    String email = user.email.toString();
    DatabaseReference listaRef = FirebaseDatabase.instance.ref().child('listas_de_compras');

    // Faz a consulta para buscar as listas onde o usuário está incluído como membro
    DatabaseEvent dbEvent = await listaRef.once();

    // Limpa a lista antes de preenchê-la com os novos dados
    listListaDeCompras.clear();

    // Verifica se o snapshot tem algum valor
    if (dbEvent.snapshot.value != null) {
      // Converte o valor para o tipo correto (Map<String, dynamic>?)
      DataSnapshot dataSnapshot = dbEvent.snapshot;
      print(dataSnapshot.value);

      Map<Object?, Object?> dataMap = dataSnapshot.value as Map<Object?, Object?>;
      Map<String, dynamic> dataMapConverted = convertMap(dataMap);

      // Itera sobre cada par chave/valor no mapa
      dataMapConverted?.forEach((key, value) {
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
                  item['categoria'],
                );
              }).toList();
            }

            ListaDeCompras lista = ListaDeCompras(
              value['nome'],
              CustomColorUtils.getCustomColor(value['cor']),
              itens: itens,
              membros: membros.cast<String>(),
            );
            lista.id = value['id'];
            listListaDeCompras.add(lista);

        }
      });
    }
  }

  Future<void> salvarListaDeCompras(ListaDeCompras listaDeCompras) async {
    try {
      DatabaseReference listaRef = _database.ref().child('listas_de_compras').child(listaDeCompras.id.toString());

      await listaRef.set({
        'id': listaDeCompras.id,
        'nome': listaDeCompras.nome,
        'cor': listaDeCompras.cor.toString(),
        'itens': listaDeCompras.itens?.map((item) => {
          'nome': item.nome,
          'quantidade': item.quantidade,
          'unidade': item.unidade.index,
          'categoria': item.categoria,
          'status': item.status,
        }).toList(),
        'membros': listaDeCompras.membros,
      });
    } catch (e) {
      print('Erro ao salvar a lista de compras: $e');
    }
  }

  void checkForNotifications() async {
    await Provider.of<NotificationService>(context, listen: false).checkForNotifications();
  }

  void initializeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false).initialize();
  }

}