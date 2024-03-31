import '../util/banco.dart';

class EquipamentoDao {
  static const String _tablename = 'equipamento';
  static const String _descricao = 'descricao';
  static const String _tipo = 'tipo';
  static const String _codigo = 'codigo';
  static const String _foto = 'foto';
  static const String _id = 'id';

  save(Equipamento model) async {
    var itemExists = await find(model.codigo);
    Map<String, dynamic> modelMap = toMap(model);
    if (itemExists.isEmpty) {
      await supabase.from(_tablename).insert({
        _descricao: model.descricao,
        _tipo: model.tipo,
        _codigo: model.codigo,
        _foto: model.foto,
      });
    } else {
      model.id = itemExists.last.id;
      await supabase
          .from(_tablename)
          .update(modelMap)
          .eq('id', model.id.toString());
    }
  }

  Map<String, dynamic> toMap(Equipamento model) {
    final Map<String, dynamic> mapa = {};
    mapa[_descricao] = model.descricao;
    mapa[_tipo] = model.tipo;
    mapa[_codigo] = model.codigo;
    mapa[_foto] = model.foto;
    return mapa;
  }

  Future<List<Equipamento>> findAll() async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().order(_descricao, ascending: true);
    return toList(result);
  }

  List<Equipamento> toList(List<Map<String, dynamic>> mapa) {
    final List<Equipamento> models = [];
    for (Map<String, dynamic> linha in mapa) {
      final Equipamento model = Equipamento(
        linha[_descricao],
        linha[_tipo],
        linha[_codigo],
        linha[_foto],
        linha[_id],
      );
      models.add(model);
    }
    return models;
  }

  Future<List<Equipamento>> find(String codigo) async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().eq(_codigo, codigo);
    return toList(result);
  }

  Future<Equipamento> findID(String id) async {
    final Map<String, dynamic> result =
    await supabase.from(_tablename).select().eq(_id, id).single();
    final Equipamento model = Equipamento(
      result[_descricao],
      result[_tipo],
      result[_codigo],
      result[_foto],
      result[_id],
    );
    return model;
  }

  delete(String id) async {
    return await supabase.from(_tablename).delete().eq(_id, id);
  }
}

class Equipamento{
  String? id;
  String descricao;
  String tipo;
  String codigo;
  String? foto;

  Equipamento(this.descricao, this.tipo, this.codigo,
      [this.foto, this.id]);

  @override
  String toString() {
    return '$descricao $tipo $codigo $foto $id';
  }
}
