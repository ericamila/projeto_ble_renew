import '../util/banco.dart';

class MovimentoDao {
  static const String _tablename = 'registro_movimentacao';
  static const String _dataHora = 'data_hora';
  static const String _alarme = 'alarme_id';
  static const String _raspberry = 'raspberry_id';
  static const String _dispositivo = 'dispositivo_id';
  static const String _id = 'id';

  Map<String, dynamic> toMap(Movimento model) {
    final Map<String, dynamic> mapa = {};
    mapa[_dataHora] = model.dataHora;
    mapa[_alarme] = model.alarme;
    mapa[_raspberry] = model.raspberry;
    mapa[_dispositivo] = model.dispositivo;
    return mapa;
  }

  Future<List<Movimento>> findAll() async {
    final List<Map<String, dynamic>> result = await supabase
        .from(_tablename)
        .select()
        .order(_dataHora, ascending: false);
    return toList(result);
  }

  List<Movimento> toList(List<Map<String, dynamic>> mapa) {
    final List<Movimento> model = [];
    for (Map<String, dynamic> linha in mapa) {
      final Movimento alarme = Movimento(
        dataHora: DateTime.parse(linha[_dataHora]),
        alarme: linha[_alarme],
        raspberry: linha[_raspberry],
        dispositivo: linha[_dispositivo],
        id: linha[_id],
      );
      model.add(alarme);
    }
    return model;
  }

  Future<Movimento> findID(String id) async {
    final Map<String, dynamic> result =
        await supabase.from(_tablename).select().eq('id', id).single();
    final Movimento model = Movimento(
      dataHora: result[_dataHora],
      alarme: result[_alarme],
      raspberry: result[_raspberry],
      dispositivo: result[_dispositivo],
      id: result[_id],
    );
    return model;
  }
}

class Movimento {
  int? id;
  DateTime dataHora;
  int alarme;
  int raspberry;
  String dispositivo;

  Movimento(
      {required this.dataHora,
      required this.alarme,
      required this.raspberry,
      required this.dispositivo,
      this.id});

  Movimento.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        dataHora = map["data_hora"],
        alarme = map["alarme_id"],
        raspberry = map["raspberry_id"],
        dispositivo = map["dispositivo_id"];

  @override
  String toString() {
    return '$dataHora $alarme $raspberry, $dispositivo, $id';
  }
}
