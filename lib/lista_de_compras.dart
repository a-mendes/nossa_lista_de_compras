class ListaDeCompras {
  String nome;
  List<Item> itens;
  List<String> membros;

  ListaDeCompras(this.nome, {List<Item>? itens, List<String>? membros})
      : itens = itens ?? [],
        membros = membros ?? [];

  String get getName {
    return nome;
  }

  int addItem(String nomeItem, int qtde){
    if(qtde <= 0) {
      return 0;
    }
    if(nomeItem.isEmpty){
      return 0;
    }
    itens.add(Item(nomeItem, qtde, false));
    return 1;
  }
}

class Item{
  String nome;
  int quantidade;
  bool status;

  Item(this.nome, this.quantidade, this.status);
}