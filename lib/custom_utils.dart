Map<String, dynamic> convertMap(Map<Object?, Object?> map) {
  // Cria um novo mapa vazio para a conversão
  Map<String, dynamic> convertedMap = {};

  // Itera sobre cada par chave/valor no mapa original
  map.forEach((key, value) {
    // Converte a chave para String e o valor para dynamic usando MapEntry
    convertedMap[convertKey(key)] = convertValue(value);
  });

  return convertedMap;
}

String convertKey(Object? key) {
  // Converte a chave para String (ou qualquer outra lógica desejada)
  return key.toString();
}

dynamic convertValue(Object? value) {
  // Converte o valor para dynamic (ou qualquer outra lógica desejada)
  return value;
}