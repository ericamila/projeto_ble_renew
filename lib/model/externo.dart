import 'package:projeto_ble_renew/model/pessoa_fisica.dart';
import '../util/banco.dart';
import 'area.dart';

class ExternoDao {
  static const String _tablename = 'externo';
  static const String _nome = 'nome';
  static const String _cpf = 'cpf';
  static const String _tipoExterno = 'tipo_externo';
  static const String _tipoPaciente = 'tipo_paciente';
  static const String _foto = 'foto';
  static const String _area = 'area_id';
  static const String _paciente = 'externo_id';
  static const String _id = 'id';

  save(Externo model) async {
    var itemExists = await find(model.cpf);
    Map<String, dynamic> modelMap = toMap(model);
    if (itemExists.isEmpty) {
      await supabase.from(_tablename).insert({
        _nome: model.nome,
        _cpf: model.cpf,
        _tipoExterno: model.tipoExterno,
        _tipoPaciente: model.tipoPaciente,
        _foto : model.foto,
        _area : model.area,
        _paciente : model.paciente
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
    mapa[_area] = model.area;
    mapa[_paciente] = model.paciente;
    return mapa;
  }

  Future<List<Externo>> findAll() async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().order(_nome, ascending: true);
    return toList(result);
  }

  Future<List<Externo>> findAllType(String tipo) async {
    final List<Map<String, dynamic>> result = await supabase
        .from(_tablename)
        .select()
        .eq('tipo_externo', tipo)
        .order(_nome, ascending: true);
    return toList(result);
  }

  Future<List<Externo>> findAllTypeAC() async {
    final List<Map<String, dynamic>> result = await supabase
        .from(_tablename)
        .select()
        .or('tipo_externo.eq.Visitante,tipo_externo.eq.Acompanhante')
        .order(_nome, ascending: true);
    return toList(result);
  }

  List<Externo> toList(List<Map<String, dynamic>> mapa) {
    final List<Externo> models = [];
    for (Map<String, dynamic> linha in mapa) {
      final Externo model = Externo(
        nome: linha[_nome],
        cpf: linha[_cpf],
        tipoExterno: linha[_tipoExterno],
        tipoPaciente: linha[_tipoPaciente],
        foto: linha[_foto],
        area: linha[_area],
        paciente: linha[_paciente],
        id: linha[_id],
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
      nome: result[_nome],
      cpf: result[_cpf],
      tipoExterno: result[_tipoExterno],
      tipoPaciente: result[_tipoPaciente],
      foto: result[_foto],
      area: result[_area],
      paciente: result[_paciente],
      id: result[_id],
    );
    return model;
  }

  Externo fromMap (Map<String, dynamic> result){
    Externo model = Externo(
      nome: result[_nome],
      cpf: result[_cpf],
      tipoExterno: result[_tipoExterno],
      tipoPaciente: result[_tipoPaciente],
      foto: result[_foto],
      area: result[_area],
      paciente: result[_paciente],
      id: result[_id],
    );
    return model;
  }

  delete(String id) async {
    return await supabase.from(_tablename).delete().eq('id', id);
  }
}

class Externo extends PessoaFisica {
  String? tipoPaciente;
  String? paciente;

  Externo(
      {required super.nome,
      required super.cpf,
      required super.tipoExterno,
      this.tipoPaciente,
      this.paciente,
      super.foto,
      super.area,
      super.id});

  @override
  String toString() {
    return '$nome \n$cpf \n$tipoExterno \n${Area.fromId(area!).descricao}';
  }
}
