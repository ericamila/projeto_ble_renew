import '../util/banco.dart';

class DispositivoDao {
  static const String _tablename = 'dispositivo';
  static const String _nome = 'nome';
  static const String _tag = 'tag';
  static const String _tipo = 'tipo';
  static const String _status = 'status';
  static const String _mac= 'mac';
  static const String _id = 'id';

  save(Dispositivo model) async {
    var itemExists = await find(model.mac!);
    Map<String, dynamic> modelMap = toMap(model);
    if (itemExists.isEmpty) {
      await supabase.from(_tablename).insert({
        _nome: model.nome,
        _tag: model.tag,
        _tipo: model.tipo,
        _status: model.status,
        _mac: model.mac,
      });
    } else {
      model.id = itemExists.last.id;
      await supabase
          .from(_tablename)
          .update(modelMap)
          .eq('id', model.id.toString());
    }
  }

  Map<String, dynamic> toMap(Dispositivo model) {
    final Map<String, dynamic> mapa = {};
    mapa[_nome] = model.nome;
    mapa[_tag] = model.tag;
    mapa[_tipo] = model.tipo;
    mapa[_status] = model.status;
    mapa[_mac] = model.mac;
    return mapa;
  }

  Future<List<Dispositivo>> findAll() async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().order(_nome, ascending: true);
    return toList(result);
  }

  List<Dispositivo> toList(List<Map<String, dynamic>> mapa) {
    final List<Dispositivo> models = [];
    for (Map<String, dynamic> linha in mapa) {
      final Dispositivo model = Dispositivo(
        linha[_nome],
        linha[_tag],
        linha[_tipo],
        linha[_status],
        linha[_mac],
        linha[_id],
      );
      models.add(model);
    }
    return models;
  }

  Future<List<Dispositivo>> find(String mac) async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().eq(_mac, mac);
    return toList(result);
  }

  Future<Dispositivo> findID(String id) async {
    final Map<String, dynamic> result =
    await supabase.from(_tablename).select().eq(_id, id).single();
    final Dispositivo model = Dispositivo(
      result[_nome],
      result[_tag],
      result[_tipo],
      result[_status],
      result[_mac],
      result[_id],
    );
    return model;
  }

  delete(String id) async {
    return await supabase.from(_tablename).delete().eq(_id, id);
  }
}

class Dispositivo{
  String? id;
  String? nome;
  String? tag;
  String? tipo;
  bool? status;
  String? mac;

  Dispositivo(this.nome, this.tag, this.tipo, this.status, this.mac,[this.id]);

  Dispositivo.fromMap(Map map) {
    id = map["id"];
    tag = map["tag"];
    status = map["status"];
    mac = map["mac"];
    nome = map["nome"];
    tipo = map["tipo"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "tag": tag,
      "status": status,
      "mac": mac,
      "nome": nome,
      "tipo": tipo,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  @override
  String toString() {
    return '$nome $tag $tipo $status $mac $id';
  }
}
