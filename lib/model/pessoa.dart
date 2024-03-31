class Pessoa {
  String? id;
  String nome;

  Pessoa(this.nome, [this.id]);

  Pessoa.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        nome = map["nome"];
}
