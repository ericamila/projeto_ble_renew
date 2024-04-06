import '../util/banco.dart';

class AreaDao {
  static const String _tablename = 'area';
  static const String _descricao = 'descricao';
  static const String _hospital = 'hospital';
  static const String _id = 'id';

  save(Area model) async {
    var itemExists = await find(model.id);
    Map<String, dynamic> modelMap = toMap(model);
    if (itemExists.isEmpty) {
      await supabase.from(_tablename).insert({
        _descricao: model.descricao,
        _hospital: model.hospital
      });
    } else {
      model.id = itemExists.last.id;
      await supabase
          .from(_tablename)
          .update(modelMap)
          .eq('id', model.id.toString());
    }
  }

  Map<String, dynamic> toMap(Area model) {
    final Map<String, dynamic> mapa = {};
    mapa[_descricao] = model.descricao;
    mapa[_hospital] = model.hospital;
    return mapa;
  }

  Future<List<Area>> findAll() async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().order(_descricao, ascending: true);
    return toList(result);
  }

  List<Area> toList(List<Map<String, dynamic>> mapa) {
    final List<Area> models = [];
    for (Map<String, dynamic> linha in mapa) {
      final Area model = Area(
       descricao:  linha[_descricao],
       hospital: linha[_hospital],
       id: linha[_id],
      );
      models.add(model);
    }
    return models;
  }

  Future<List<Area>> find(int id) async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().eq(_id, id);
    return toList(result);
  }

  delete(String id) async {
    return await supabase.from(_tablename).delete().eq(_id, id);
  }
}

class Area{
  int id;
  String descricao;
  int? hospital;

  Area({required this.descricao, required this.id, this.hospital});

  Area.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        descricao = map["descricao"];

  @override
  String toString() {
    return '$descricao $hospital $id';
  }
}
