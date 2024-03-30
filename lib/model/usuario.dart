import 'package:projeto_ble_renew/model/pessoa.dart';
import '../util/banco.dart';

class UsuarioDao {
  static const String _tablename = 'usuario';
  static const String _nome = 'username';
  static const String _email = 'email';
  static const String _funcionario = 'funcionario_id';
  static const String _uid = 'uid';
  static const String _id = 'id';

  save(Usuario usuario) async {
    var itemExists = await find(usuario.email);
    Map<String, dynamic> usuarioMap = toMap(usuario);
    if (itemExists.isEmpty) {
      await supabase.from(_tablename).insert(usuarioMap);
    } else {
      usuario.id = itemExists.last.id;
      await supabase
          .from(_tablename)
          .update(usuarioMap)
          .eq('id', usuario.id.toString());
    }
  }

  Map<String, dynamic> toMap(Usuario usuario) {
    final Map<String, dynamic> mapa = {};
    mapa[_nome] = usuario.nome;
    mapa[_email] = usuario.email;
    mapa[_funcionario] = usuario.funcionario;
    mapa[_uid] = usuario.uid;
    return mapa;
  }

  Future<List<Usuario>> findAll() async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().order(_nome, ascending: true);
    return toList(result);
  }

  List<Usuario> toList(List<Map<String, dynamic>> mapa) {
    final List<Usuario> usuarios = [];
    for (Map<String, dynamic> linha in mapa) {
      final Usuario model = Usuario(
        linha[_nome],
        linha[_email],
        linha[_funcionario],
        linha[_uid],
        linha[_id],
      );
      usuarios.add(model);
    }
    return usuarios;
  }

  Future<List<Usuario>> find(String email) async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().eq('email', email);
    return toList(result);
  }

  Future<List<Usuario>> findID(int id) async {
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().eq('id', id);
    return toList(result);
  }

  delete(int id) async {
    return await supabase.from(_tablename).delete().eq('id', id);
  }
}

class Usuario extends Pessoa {
  String email;
  String? uid;
  int funcionario;

  Usuario(super.nome, this.email, this.funcionario, [this.uid, super.id]);

  @override
  String toString() {
    return '$nome $uid $email $id $funcionario';
  }
}
