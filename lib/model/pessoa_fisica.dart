import 'package:projeto_ble_renew/model/pessoa.dart';

abstract class PessoaFisica extends Pessoa {
  String cpf;
  String? foto;

  PessoaFisica(super.nome, this.cpf, this.foto, [super.id]);

}
