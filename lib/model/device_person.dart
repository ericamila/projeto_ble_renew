class DispUser {
  String nome;
  String mac;
  String tipo;
  String tag;
  int id;

  DispUser({
    required this.nome,
    required this.mac,
    required this.tipo,
    required this.tag,
    required this.id,
  });

  //receber do banco
  DispUser.fromMap(Map<String, dynamic> map)
      : nome = map["nome"].toString(),
        mac = map["mac"],
        tipo = map["tipo"],
        tag = map["tag"],
        id = map["id"];

  //MAPA PARA LISTA
  List<DispUser> toList(List<Map<String, dynamic>> mapa) {
    final List<DispUser> vinculos = [];
    for (Map<String, dynamic> linha in mapa) {
      final DispUser vinculo = DispUser(
        nome: linha[nome],
        mac: linha[mac],
        tipo: linha[tipo],
        tag: linha[tag],
        id: linha[id.toString()],
      );

      vinculos.add(vinculo);
    }
    return vinculos;
  }
}
