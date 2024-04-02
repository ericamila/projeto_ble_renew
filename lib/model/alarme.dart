import '../util/banco.dart';

class AlarmeDao {
  static const String _tablename = 'pessoa_fisica';
  static const String _descricao = 'descricao';
  static const String _codigo = 'codigo';
  static const String _id = 'id';


  Map<String, dynamic> toMap(Alarme model) {
    final Map<String, dynamic> mapa = {};
    mapa[_descricao] = model.descricao;
    mapa[_codigo] = model.codigo;
    return mapa;
  }

  Future<List<Alarme>> findAll() async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().order(_descricao, ascending: true);
    return toList(result);
  }

  List<Alarme> toList(List<Map<String, dynamic>> mapa) {
    final List<Alarme> model = [];
    for (Map<String, dynamic> linha in mapa) {
      final Alarme alarme = Alarme(
        linha[_descricao],
        linha[_codigo],
        linha[_id],
      );
      model.add(alarme);
    }
    return model;
  }

  Future<List<Alarme>> findNome(String descricao) async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().eq('descricao', descricao);
    return toList(result);
  }

  Future<Alarme> findID(String id) async {
    final Map<String, dynamic> result =
    await supabase.from(_tablename).select().eq('id', id).single();
    final Alarme model = Alarme(
      result[_descricao],
      result[_codigo],
      result[_id],
    );
    return model;
  }

}

class Alarme {
  String? id;
  String descricao;
  String codigo;

  Alarme(this.descricao,this.codigo, [this.id]);

  Alarme.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        descricao = map["descricao"],
        codigo = map["codigo"];

  @override
  String toString() {
    return '$descricao $codigo $id';
  }
}
