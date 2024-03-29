import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/pessoa_fisica.dart';

import '../util/banco.dart';

class FuncionarioDao {
  static const String _tablename = 'funcionario';
  static const String _nome = 'nome';
  static const String _cpf = 'cpf';
  static const String _tipoFuncionario = 'tipo_funcionario';
  static const String _cargo = 'cargo_id';
  static const String _id = 'id';

  save(Funcionario funcionario) async {
    print('Iniciando o save: ');
    var itemExists = await find(funcionario.cpf);
    Map<String, dynamic> funcionarioMap = toMap(funcionario);
    if (itemExists.isEmpty) {
      print('a Funcionario não Existia.');
      await supabase.from(_tablename).insert({
        'nome': funcionario.nome,
        'cpf': funcionario.cpf,
        'tipo_funcionario': funcionario.tipoFuncionario,
        'cargo_id': funcionario.cargo
      });
    } else {
      funcionario.id = itemExists.last.id;

      print('a Funcionario existia!');
      print(funcionarioMap);
      await supabase
          .from(_tablename)
          .update(funcionarioMap)
          .eq('id', funcionario.id.toString());
    }
  }

  Map<String, dynamic> toMap(Funcionario funcionario) {
    print('Convertendo to Map: ${funcionario.id}');
    final Map<String, dynamic> mapa = Map();
    mapa[_nome] = funcionario.nome;
    mapa[_cpf] = funcionario.cpf;
    mapa[_tipoFuncionario] = funcionario.tipoFuncionario;
    mapa[_cargo] = funcionario.cargo;
    print('Mapa de Funcionarios: $mapa');
    return mapa;
  }

  Future<List<Funcionario>> findAll() async {
    print('Acessando o findAll: ');
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().order(_nome, ascending: true);
    print('Procurando dados no banco de dados... encontrado: $result');
    return toList(result);
  }

  List<Funcionario> toList(List<Map<String, dynamic>> mapa) {
    final List<Funcionario> funcionarios = [];
    for (Map<String, dynamic> linha in mapa) {
      final Funcionario funcionario = Funcionario(
        linha[_nome],
        linha[_cpf],
        linha[_tipoFuncionario],
        linha[_cargo],
        linha[_id],
      );
      funcionarios.add(funcionario);
    }
    print('Lista de Funcionarios do toList: ${funcionarios.toString()}');
    return funcionarios;
  }
//
  Future<List<Funcionario>> find(String cpf) async {
    print('Acessando find: ');
    print('Procurando funcionario com o cpf: $cpf');
    final List<Map<String, dynamic>> result =
        await supabase.from(_tablename).select().eq('cpf', cpf);
    print('Funcionario encontrado: ${result}');

    return toList(result);
  }

  delete(int id) async {
    print('Deletando funcionario: $id');
    return await supabase.from(_tablename).delete().eq('id', id);
  }
}

class Funcionario extends  PessoaFisica {
  String tipoFuncionario;
  int cargo;

  Funcionario(super.nome, super.cpf, this.tipoFuncionario, this.cargo,
      [super.id]);

  @override
  String toString() {
    return '$nome $cpf $tipoFuncionario $cargo $id';
  }

}
