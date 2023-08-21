import 'dart:math';

class Contact{
  String nome;
  String? email;
  var id = Random().nextInt(100000000);

  Contact(this.nome, this.email);
}