import '../util/banco.dart';

class PessoaDao {
  static const String _tablename = 'pessoa_fisica';
  static const String _nome = 'nome';
  static const String _id = 'id';
  static const String _cpf = 'cpf';

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
        nome: linha[_nome],
        cpf: linha[_cpf],
        id: linha[_id],
      );
      model.add(pessoa);
    }
    return model;
  }

  Future<List<Pessoa>> findNome(String nome) async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().eq(_nome, nome);
    return toList(result);
  }

  Future<List<Pessoa>> findCPF(String cpf) async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().eq(_cpf, cpf);
    return toList(result);
  }

  Future<Pessoa> findID(String id) async {
    final Map<String, dynamic> result =
        await supabase.from(_tablename).select().eq('id', id).single();
    final Pessoa model =
        Pessoa(nome: result[_nome], cpf: result[_cpf], id: result[_id]);
    return model;
  }
}

class Pessoa {
  String? id;
  String nome;
  String cpf;

  Pessoa({required this.nome, required this.cpf, this.id});

  Pessoa.fromMap(Map<String, dynamic> map)
      : id = map["uuid"],
        nome = map["nome"],
        cpf = map["cpf"];

  @override
  String toString() {
    return '$nome $cpf $id';
  }
}
