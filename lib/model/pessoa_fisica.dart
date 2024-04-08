import 'package:projeto_ble_renew/model/pessoa.dart';

abstract class PessoaFisica extends Pessoa {
  String? foto;

  PessoaFisica(
      {required super.nome, required super.cpf, required this.foto, super.id});
}
