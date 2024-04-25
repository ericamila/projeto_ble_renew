import 'package:projeto_ble_renew/model/pessoa_fisica.dart';
import '../util/banco.dart';

class FuncionarioDao {
  static const String _tablename = 'funcionario';
  static const String _nome = 'nome';
  static const String _cpf = 'cpf';
  static const String _cargo = 'cargo_id';
  static const String _foto = 'foto';
  static const String _id = 'id';
  static const String _tipoExterno = 'tipo_externo';

  save(Funcionario model) async {
    var itemExists = await find(model.cpf);
    Map<String, dynamic> funcionarioMap = toMap(model);
    if (itemExists.isEmpty) {
      await supabase.from(_tablename).insert({
        _nome: model.nome,
        _cpf: model.cpf,
        _foto: model.foto,
        _cargo: model.cargo,
        _tipoExterno: 'Funcionário',
      });
    } else {
      model.id = itemExists.last.id;
      await supabase
          .from(_tablename)
          .update(funcionarioMap)
          .eq('id', model.id.toString());
    }
  }

  Map<String, dynamic> toMap(Funcionario model) {
    final Map<String, dynamic> mapa = {};
    mapa[_nome] = model.nome;
    mapa[_cpf] = model.cpf;
    mapa[_cargo] = model.cargo;
    mapa[_foto] = model.foto;
    mapa[_tipoExterno] = 'Funcionário';

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
        nome: linha[_nome],
        cpf: linha[_cpf],
        cargo: linha[_cargo],
        foto: linha[_foto],
        id: linha[_id],
        tipoExterno: linha[_tipoExterno],
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
      nome: result[_nome],
      cpf: result[_cpf],
      cargo: result[_cargo],
      foto: result[_foto],
      id: result[_id],
      tipoExterno: result[_tipoExterno],
    );
    return funcionario;
  }

  Future<Funcionario> findCPFUnico(String cpf) async {
    final Map<String, dynamic> result =
        await supabase.from(_tablename).select().eq('cpf', cpf).single();
    final Funcionario funcionario = Funcionario(
      nome: result[_nome],
      cpf: result[_cpf],
      cargo: result[_cargo],
      foto: result[_foto],
      id: result[_id],
      tipoExterno: result[_tipoExterno],
    );
    return funcionario;
  }

  delete(String id) async {
    return await supabase.from(_tablename).delete().eq('id', id);
  }
}

class Funcionario extends PessoaFisica {
  int cargo;

  Funcionario(
      {required super.nome,
      required super.cpf,
      required this.cargo,
      super.tipoExterno = 'Funcionário',
      super.foto,
      super.id});

  @override
  String toString() {
    return '$nome $cpf $cargo $foto $id';
  }
}
