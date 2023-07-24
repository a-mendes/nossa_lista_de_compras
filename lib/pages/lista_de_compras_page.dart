import 'package:flutter/material.dart';
import '../lista_de_compras.dart';

class FormPage extends StatefulWidget {
  final ListaDeCompras listaDeCompras;

  const FormPage({Key? key, required this.listaDeCompras}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage>{
  Item item = Item("", 0, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listaDeCompras.getName),
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
    widget.listaDeCompras.addItem(item.nome, item.quantidade);
    setState(() {
      item.nome = '';
      item.quantidade = 0;
    });
  }
  void popItem(){

  }

  int itemValidator(){
    if (item.nome.isNotEmpty && item.quantidade != 0) {
      return 1;
    }
    return 0;
  }

  Widget showItensLista(){
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: widget.listaDeCompras.itens.length,
      itemBuilder: (context, index) {
        final item = widget.listaDeCompras.itens[index];
        final displayText = 'Nome: ${item.nome} - Quantidade: ${item.quantidade}';

        return CheckboxListTile(
          title: RichText(
            text: TextSpan(
              text: displayText,
              style: TextStyle(
                decoration: item.status ? TextDecoration.lineThrough : TextDecoration.none,
                color: item.status ? Colors.green : Colors.black,
              ),
            ),
          ),

          value: item.status,
          onChanged: (value) {
                setState(() {
              item.status = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Colors.green,
          checkColor: Colors.white,
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
                  onChanged: (value) => item.nome = value!,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null) {
                      return value.isNotEmpty ? null : 'Digite a quantidade';
                    } else {
                      return 'Digite a quantidade';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Quantidade'),
                  onChanged: (value) => item.quantidade = int.parse(value!),
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
}