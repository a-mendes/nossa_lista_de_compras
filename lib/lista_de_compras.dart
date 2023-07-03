class ListaDeCompras {
  String nome;
  List<String> itens;
  List<String> membros;

  ListaDeCompras(this.nome, {List<String>? itens, List<String>? membros})
      : itens = itens ?? [],
        membros = membros ?? [];
}