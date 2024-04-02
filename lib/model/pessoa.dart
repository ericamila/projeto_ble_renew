import '../util/banco.dart';

class PessoaDao {
  static const String _tablename = 'pessoa_fisica';
  static const String _nome = 'nome';
  static const String _id = 'id';


  Map<String, dynamic> toMap(Pessoa model) {
    final Map<String, dynamic> mapa = {};
    mapa[_nome] = model.nome;
    return mapa;
  }

  Future<List<Pessoa>> findAll() async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().order(_nome, ascending: true);
    return toList(result);
  }

  List<Pessoa> toList(List<Map<String, dynamic>> mapa) {
    final List<Pessoa> model = [];
    for (Map<String, dynamic> linha in mapa) {
      final Pessoa pessoa = Pessoa(
        linha[_nome],
        linha[_id],
      );
      model.add(pessoa);
    }
    return model;
  }

  Future<List<Pessoa>> findNome(String nome) async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().eq('nome', nome);
    return toList(result);
  }

  Future<Pessoa> findID(String id) async {
    final Map<String, dynamic> result =
    await supabase.from(_tablename).select().eq('id', id).single();
    final Pessoa model = Pessoa(
      result[_nome],
      result[_id],
    );
    return model;
  }

}

class Pessoa {
  String? id;
  String nome;

  Pessoa(this.nome, [this.id]);

  Pessoa.fromMap(Map<String, dynamic> map)
      : id = map["uuid"],
        nome = map["nome"];

  @override
  String toString() {
    return '$nome $id';
  }
}
