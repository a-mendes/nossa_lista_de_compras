import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../contact.dart';
import '../custom_utils.dart';

final FirebaseDatabase _database = FirebaseDatabase.instance;

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final txtControlerNome = TextEditingController();
  final txtControlerEmail = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;
  List<Contact> listaContatos = [];

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
                future: buscarContatos(),
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
                    return listaContatos.isEmpty
                        ? const Text('Você ainda não adicionou nenhum contato')
                        : showListaContatos();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddContatoDialog,
        tooltip: 'Adicionar Contato',
        child: const Icon(Icons.add),
      ),
    );
  }

  void addContato(){
    Contact contatoAdd = Contact(txtControlerNome.text, txtControlerEmail.text);

    listaContatos.add(contatoAdd);
    salvarContatos(contatoAdd);
    setState(() {
      txtControlerNome.text = '';
      txtControlerEmail.text = '';
    });
  }

  void showAddContatoDialog(){
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Novo Contato'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (nameInput) {
                    if (nameInput != null) {
                      return nameInput.isNotEmpty ? null : 'Digite algum texto';
                    } else {
                      return 'Digite algum texto';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Nome do contato'),
                  initialValue: txtControlerNome.text,
                  onChanged: (value) => txtControlerNome.text = value,
                ),
                TextFormField(
                  validator: (emailInput) {
                    if (emailInput != null) {
                      return emailInput.isNotEmpty ? null : 'Digite algum texto';
                    } else {
                      return 'Digite algum texto';
                    }
                  },
                  decoration: const InputDecoration(hintText: 'Email do contato'),
                  initialValue: txtControlerEmail.text,
                  onChanged: (emailInput) => txtControlerEmail.text = emailInput,
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
                addContato();
                Navigator.pop(context);
              },
              child: const Text('Adicionar Contato'),
            ),
          ],
        );
      },
    );
  }

  void showEditContatoDialog(BuildContext context, Contact contact, int index){
    txtControlerNome.text = contact.nome;
    txtControlerEmail.text = contact.email.toString();

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
                  controller: txtControlerNome,
                  decoration: const InputDecoration(hintText: 'Nome'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: txtControlerEmail,
                        decoration: const InputDecoration(hintText: 'Email'),
                      ),
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
                  contact.nome = txtControlerNome.text;
                  contact.email = txtControlerEmail.text;
                });
                salvarContatos(contact);
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  listaContatos.removeAt(index);
                  Navigator.pop(context); // Fechando o diálogo de confirmação
                });
                deletarContato(contact);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteContatoDialog(BuildContext context, int index){
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
                  deletarContato(listaContatos[index]);
                  Navigator.pop(context);
                });
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  Widget showListaContatos() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: listaContatos.length,
      itemBuilder: (context, index) {
        final contact = listaContatos[index];
        final displayText = '${contact?.nome}';

        return InkWell(
          onTap: () {
            showEditContatoDialog(context, contact, index);
          },
          splashColor: Colors.lightBlueAccent, // Cor do "splash" ao pressionar
          highlightColor: Colors.blue, // Cor de destaque ao pressionar
          child: Container(
            color: index % 2 == 0 ? Colors.deepPurple.shade50 : Colors.white, // Alterna a cor do fundo
            child: ListTile(
              title: RichText(
                text: TextSpan(
                  text: displayText,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> buscarContatos() async {
    String uid = user.uid;
    DatabaseReference contatosRef = FirebaseDatabase.instance.ref().child('contatos').child(uid);

    // Faz a consulta para buscar os contatos do usuário
    DatabaseEvent dbEvent = await contatosRef.once();

    // Limpa a lista antes de preenchê-la com os novos dados
    listaContatos.clear();

    // Verifica se o snapshot tem algum valor
    if (dbEvent.snapshot.value != null) {
      // Converte o valor para o tipo correto (Map<dynamic, dynamic>?)
      Map<dynamic, dynamic>? dataMap = dbEvent.snapshot.value as Map<dynamic, dynamic>?;

      if (dataMap != null) {
        // Itera sobre cada contato no mapa
        dataMap.forEach((key, value) {
          String contatoNome = value['nome'];
          String contatoEmail = value['email'];

          // Cria uma instância de Contact com os dados do contato
          Contact contato = Contact(
            contatoNome,
            contatoEmail,
          );
          contato.id = value['id'];
          listaContatos.add(contato);
        });
      }
    }
    if(listaContatos.isNotEmpty){
      listaContatos.sort((a, b) => a.nome.compareTo(b.nome));
    }
  }

  Future<void> salvarContatos(Contact contatoSave) async {
    try {
      if(contatoSave.nome.isNotEmpty  &&  contatoSave.email != null){
        DatabaseReference listaRef = _database.ref().child('contatos').child(user.uid);

        DatabaseReference newContactRef = listaRef.child(contatoSave.id.toString());  // Cria um novo nó filho com um ID exclusivo
        await newContactRef.set({
          'id': contatoSave.id,
          'nome': contatoSave.nome,
          'email': contatoSave.email,
        });

        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text('Informações salvas com sucesso!'),
            );
          },
        );
      }
    } catch (e) {
      print('Erro ao salvar a Contatos: $e');
    }
  }

  Future<void> deletarContato(Contact contact) async {
    try {
      DatabaseReference listaRef = _database.ref().child('contatos').child(user.uid);

      var contatoId = contact.id; // Substitua isso pelo ID real do contato

      DatabaseReference contatoRef = listaRef.child(contatoId.toString());
      await contatoRef.remove();

      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text('Contato removido com sucesso!'),
          );
        },
      );
    } catch (e) {
      print('Erro ao deletar o contato: $e');
    }
  }
}