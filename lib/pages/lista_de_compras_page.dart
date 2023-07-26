import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../lista_de_compras.dart';

final FirebaseDatabase _database = FirebaseDatabase.instance;

class FormPage extends StatefulWidget {
  final ListaDeCompras listaDeCompras;

  const FormPage({Key? key, required this.listaDeCompras}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage>{
  Item item = Item("", 0, UnidadeDeMedida.u, false);

  final txtControlerMembro = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listaDeCompras.getName),
        actions: [
          IconButton(
            icon: const Icon(Icons.save), // Ícone de salvamento
            onPressed: salvarListaDeCompras, // Função de tratamento do evento de clique
          ),
          IconButton(
            icon: const Icon(Icons.account_box), // Ícone de salvamento
            onPressed: addMembroDialog, // Função de tratamento do evento de clique
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: widget.listaDeCompras.itens.isEmpty,
              child: const Text('Você ainda não adicionou nenhum item'),
            ),
            Expanded(
              child: showItensLista(),
            ),
          ],
        ),
      ),
       floatingActionButton: FloatingActionButton(
         onPressed: () => showAddNovoItemDialog(context),
         tooltip: 'Adicionar item',
         child: const Icon(Icons.add),
       ),
    );

  }

  void addItem(){
    widget.listaDeCompras.addItem(item.nome, item.quantidade, item.unidade);
    setState(() {
      item.nome = '';
      item.quantidade = 0;
      item.unidade = UnidadeDeMedida.u;
    });
  }

  int itemValidator(){
    if (item.nome.isNotEmpty && item.quantidade != 0) {
      return 1;
    }
    return 0;
  }

  void addMembroDialog(){
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Adicionar Membro'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: txtControlerMembro,
                  validator: (value) {
                    if (value != null) {
                      return value.isNotEmpty ? null : 'Digite algum texto';
                    } else {
                      return 'Digite algum texto';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Email do membro'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if(txtControlerMembro.toString() != ""){
                  widget.listaDeCompras.membros.add(txtControlerMembro.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar Membro'),
            ),
          ],
        );
      },
    );
  }

  Widget showItensLista(){
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: widget.listaDeCompras.itens.length,
      itemBuilder: (context, index) {
        final item = widget.listaDeCompras.itens[index];
        final displayText = '${item.nome} - ${item.quantidade} ${item.unidade.toString().split('.').last}';

        return ListTile(
          title: RichText(
            text: TextSpan(
              text: displayText,
              style: TextStyle(
                decoration: item.status ? TextDecoration.lineThrough : TextDecoration.none,
                color: item.status ? Colors.green : Colors.black,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showEditItemDialog(context, item, index);
                },
              ),
              IconButton(
                icon: const Icon(Icons.check_circle),
                color: item.status ? Colors.green : Colors.grey,
                onPressed: () {
                  setState(() {
                    item.status = !item.status;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDeleteItemDialog(context, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showAddNovoItemDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Novo Item'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value != null) {
                      return value.isNotEmpty ? null : 'Digite algum texto';
                    } else {
                      return 'Digite algum texto';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Nome do item'),
                  initialValue: item.nome,
                  onChanged: (value) => item.nome = value,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(hintText: 'Quantidade'),
                        onChanged: (value) => item.quantidade = int.parse(value),
                      ),
                    ),
                    DropdownButton<UnidadeDeMedida>(
                      value: item.unidade,
                      onChanged: (UnidadeDeMedida? newValue) {
                        setState(() {
                          item.unidade = newValue ?? UnidadeDeMedida.u;
                        });
                      },
                      items: UnidadeDeMedida.values.map((unidade) {
                        return DropdownMenuItem<UnidadeDeMedida>(
                          value: unidade,
                          child: Text(unidade.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if(itemValidator() == 1){
                  addItem();
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar Item'),
            ),
          ],
        );
      },
    );
  }

  void showEditItemDialog(BuildContext context, Item item, int index) {
    final TextEditingController nameController = TextEditingController(text: item.nome);
    final TextEditingController quantityController = TextEditingController(text: item.quantidade.toString());

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Editar Item'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Nome do item'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Quantidade'),
                      ),
                    ),
                    DropdownButton<UnidadeDeMedida>(
                      value: item.unidade,
                      onChanged: (UnidadeDeMedida? newValue) {
                        setState(() {
                          item.unidade = newValue!;
                        });
                      },
                      items: UnidadeDeMedida.values.map((unidade) {
                        return DropdownMenuItem<UnidadeDeMedida>(
                          value: unidade,
                          child: Text(unidade.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  item.nome = nameController.text;
                  item.quantidade = int.parse(quantityController.text);
                });
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteItemDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Deseja realmente excluir este item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.listaDeCompras.itens.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  Future<void> salvarListaDeCompras() async {
    ListaDeCompras listaDeCompras = widget.listaDeCompras;
    int chaveLista = listaDeCompras.id;

    try {
      DatabaseReference listaRef = _database.ref().child('listas_de_compras').child(chaveLista.toString());
      await listaRef.set({
        'id': chaveLista,
        'nome': listaDeCompras.nome,
        'itens': listaDeCompras.itens.map((item) => {
          'nome': item.nome,
          'quantidade': item.quantidade,
          'unidade': item.unidade.index,
          'status': item.status,
        }).toList(),
        'membros': listaDeCompras.membros,
      });
    } catch (e) {
      print('Erro ao salvar a lista de compras: $e');
    }
  }
}
