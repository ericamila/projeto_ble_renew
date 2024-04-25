import 'package:projeto_ble_renew/model/pessoa.dart';

abstract class PessoaFisica extends Pessoa {
  String? foto;
  int? area;


  PessoaFisica(
      {required super.nome, required super.cpf, required this.foto, this.area, super.tipoExterno, super.id});
}
