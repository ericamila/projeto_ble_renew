import 'package:projeto_ble_renew/model/pessoa.dart';

abstract class PessoaFisica extends Pessoa {
  String cpf;
  String? foto;

  PessoaFisica(
      {required super.nome, required this.cpf, required this.foto, super.id});
}
