import 'package:projeto_ble_renew/model/pessoa.dart';

abstract class PessoaFisica extends Pessoa {
  String cpf;

  PessoaFisica(super.nome, this.cpf, [super.id]);
}
