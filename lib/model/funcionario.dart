import 'package:projeto_ble_renew/model/pessoa_fisica.dart';
import '../util/banco.dart';

class FuncionarioDao {
  static const String _tablename = 'funcionario';
  static const String _nome = 'nome';
  static const String _cpf = 'cpf';
  static const String _cargo = 'cargo_id';
  static const String _foto = 'foto';
  static const String _id = 'id';

  save(Funcionario funcionario) async {
    var itemExists = await find(funcionario.cpf);
    Map<String, dynamic> funcionarioMap = toMap(funcionario);
    if (itemExists.isEmpty) {
      await supabase.from(_tablename).insert({
        'nome': funcionario.nome,
        'cpf': funcionario.cpf,
        'foto': funcionario.foto,
        'cargo_id': funcionario.cargo
      });
    } else {
      funcionario.id = itemExists.last.id;
      await supabase
          .from(_tablename)
          .update(funcionarioMap)
          .eq('id', funcionario.id.toString());
    }
  }

  Map<String, dynamic> toMap(Funcionario funcionario) {
    final Map<String, dynamic> mapa = {};
    mapa[_nome] = funcionario.nome;
    mapa[_cpf] = funcionario.cpf;
    mapa[_cargo] = funcionario.cargo;
    mapa[_foto] = funcionario.foto;
    return mapa;
  }

  Future<List<Funcionario>> findAll() async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().order(_nome, ascending: true);
    return toList(result);
  }

  List<Funcionario> toList(List<Map<String, dynamic>> mapa) {
    final List<Funcionario> funcionarios = [];
    for (Map<String, dynamic> linha in mapa) {
      final Funcionario funcionario = Funcionario(
        linha[_nome],
        linha[_cpf],
        linha[_cargo],
        linha[_foto],
        linha[_id],
      );
      funcionarios.add(funcionario);
    }
    return funcionarios;
  }

  Future<List<Funcionario>> find(String cpf) async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().eq('cpf', cpf);
    return toList(result);
  }

  Future<Funcionario> findID(String id) async {
    final Map<String, dynamic> result =
    await supabase.from(_tablename).select().eq('id', id).single();
    final Funcionario funcionario = Funcionario(
      result[_nome],
      result[_cpf],
      result[_cargo],
      result[_foto],
      result[_id],
    );
    return funcionario;
  }

  delete(String id) async {
    return await supabase.from(_tablename).delete().eq('id', id);
  }
}

class Funcionario extends PessoaFisica {
  int cargo;

  Funcionario(super.nome, super.cpf, this.cargo, [super.foto, super.id]);


  @override
  String toString() {
    return '$nome $cpf $cargo $foto $id';
  }
}
