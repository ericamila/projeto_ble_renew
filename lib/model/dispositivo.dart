import '../util/banco.dart';

class DispositivoDao {
  static const String _tablename = 'dispositivo';
  static const String _nome = 'nome';
  static const String _tag = 'tag';
  static const String _tipo = 'tipo';
  static const String _status = 'status';
  static const String _mac = 'mac';
  static const String _id = 'id';

  save(Dispositivo model) async {
    var itemExists = await findMAC(model.mac!);
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
        await supabase.from(_tablename).select().order(_tag, ascending: true);
    return toList(result);
  }

  List<Dispositivo> toList(List<Map<String, dynamic>> mapa) {
    final List<Dispositivo> models = [];
    for (Map<String, dynamic> linha in mapa) {
      final Dispositivo model = Dispositivo(
        nome: linha[_nome],
        tag: linha[_tag],
        tipo: linha[_tipo],
        status: linha[_status],
        mac: linha[_mac],
        id: linha[_id],
      );
      models.add(model);
    }
    return models;
  }

  Future<List<Dispositivo>> findMAC(String mac) async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().eq(_mac, mac);
    return toList(result);
  }

  Future<List<Dispositivo>> findTAG(String tag) async {
    final List<Map<String, dynamic>> result =
    await supabase.from(_tablename).select().eq(_tag, tag);
    return toList(result);
  }


  Future<Dispositivo> findID(String id) async {
    final Map<String, dynamic> result =
        await supabase.from(_tablename).select().eq(_id, id).single();
    final Dispositivo model = Dispositivo(
      nome: result[_nome],
      tag: result[_tag],
      tipo: result[_tipo],
      status: result[_status],
      mac: result[_mac],
      id: result[_id],
    );
    return model;
  }

  delete(String id) async {
    return await supabase.from(_tablename).delete().eq(_id, id);
  }
}

class Dispositivo {
  String? id;
  String? nome;
  String? tag;
  String? tipo;
  bool? status;
  String? mac;

  Dispositivo(
      {required this.nome,
      required this.tag,
      required this.tipo,
      required this.status,
      required this.mac,
      this.id});

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
    return 'TAG: $tag Tipo: $tipo ${(status!)? 'Vinculado' : 'Desvinculado'} $mac';
  }
}
