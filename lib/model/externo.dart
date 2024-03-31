import 'package:projeto_ble_renew/model/pessoa_fisica.dart';
import '../util/banco.dart';

class ExternoDao {
  static const String _tablename = 'externo';
  static const String _nome = 'nome';
  static const String _cpf = 'cpf';
  static const String _tipoExterno = 'tipo_externo';
  static const String _tipoPaciente = 'tipo_paciente';
  static const String _foto = 'foto';
  static const String _id = 'id';

  save(Externo model) async {
    var itemExists = await find(model.cpf);
    Map<String, dynamic> modelMap = toMap(model);
    if (itemExists.isEmpty) {
      await supabase.from(_tablename).insert({
        'nome': model.nome,
        'cpf': model.cpf,
        'tipo_externo': model.tipoExterno,
        'tipo_paciente': model.tipoPaciente,
        'foto': model.foto
      });
    } else {
      model.id = itemExists.last.id;
      await supabase
          .from(_tablename)
          .update(modelMap)
          .eq('id', model.id.toString());
    }
  }

  Map<String, dynamic> toMap(Externo model) {
    final Map<String, dynamic> mapa = {};
    mapa[_nome] = model.nome;
    mapa[_cpf] = model.cpf;
    mapa[_tipoExterno] = model.tipoExterno;
    mapa[_tipoPaciente] = model.tipoPaciente;
    mapa[_foto] = model.foto;
    return mapa;
  }

  Future<List<Externo>> findAll() async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().order(_nome, ascending: true);
    return toList(result);
  }

  Future<List<Externo>> findAllType(String tipo) async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().eq('tipo_externo', tipo).order(_nome, ascending: true);
    return toList(result);
  }

  Future<List<Externo>> findAllTypeAC() async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().or('tipo_externo.eq.Visitante,tipo_externo.eq.Acompanhante').order(_nome, ascending: true);
    return toList(result);
  }

  List<Externo> toList(List<Map<String, dynamic>> mapa) {
    final List<Externo> models = [];
    for (Map<String, dynamic> linha in mapa) {
      final Externo model = Externo(
        linha[_nome],
        linha[_cpf],
        linha[_tipoExterno],
        linha[_tipoPaciente],
        linha[_foto],
        linha[_id],
      );
      models.add(model);
    }
    return models;
  }

  Future<List<Externo>> find(String cpf) async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().eq('cpf', cpf);
    return toList(result);
  }

  Future<Externo> findID(String id) async {
    final Map<String, dynamic> result =
        await supabase.from(_tablename).select().eq('id', id).single();
    final Externo model = Externo(
      result[_nome],
      result[_cpf],
      result[_tipoExterno],
      result[_tipoPaciente],
      result[_foto],
      result[_id],
    );
    return model;
  }

  delete(String id) async {
    return await supabase.from(_tablename).delete().eq('id', id);
  }
}

class Externo extends PessoaFisica {
  String tipoExterno;
  String? tipoPaciente;

  Externo(super.nome, super.cpf, this.tipoExterno,
      [this.tipoPaciente, super.foto, super.id]);

  @override
  String toString() {
    return '$nome $cpf $tipoExterno $tipoPaciente $foto $id';
  }
}
