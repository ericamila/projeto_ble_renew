class DispUser {
  String nome;
  String mac;
  String tipo;

  DispUser(this.nome, this.mac, this.tipo);

  //receber do banco
  DispUser.fromMap(Map<String, dynamic> map)
      : nome = map["nome"].toString(),
        mac = map["mac"],
        tipo = map["tipo"];

  //MAPA PARA LISTA
  List<DispUser> toList(List<Map<String, dynamic>> mapa) {
    final List<DispUser> vinculos = [];
    for (Map<String, dynamic> linha in mapa) {
      final DispUser vinculo = DispUser(linha[nome], linha[mac], linha[tipo]);

      vinculos.add(vinculo);
    }
    return vinculos;
  }
}
