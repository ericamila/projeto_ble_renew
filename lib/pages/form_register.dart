import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/funcionario.dart';

import '../model/cargo.dart';
import '../util/constants.dart';

class FormCadastro extends StatefulWidget {
  final BuildContext funcionarioContext;
  final Funcionario? funcionarioEdit;
  final String tipoCadastro;

  const FormCadastro(
      {super.key,
      required this.funcionarioContext,
      this.funcionarioEdit,
      required this.tipoCadastro});

  @override
  State<FormCadastro> createState() => _FormCadastroState();
}

class _FormCadastroState extends State<FormCadastro> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final imagemController = TextEditingController();
  final dropCargoValue = ValueNotifier('');

  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }

  bool seEditar() {
    return (widget.funcionarioEdit != null);
  }

  @override
  Widget build(BuildContext context) {
    if (seEditar()) {
      nomeController.text = widget.funcionarioEdit!.nome;
      cpfController.text = widget.funcionarioEdit!.cpf;
      dropCargoValue.value = widget.funcionarioEdit!.cargo.toString();
    }
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cadastro de ${widget.tipoCadastro}'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              //apagar
              height: 650,
              width: 375,
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 3, color: Colors.black38),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: paddingPadraoFormulario,
                    child: TextFormField(
                      validator: (String? value) {
                        if (valueValidator(value)) {
                          return 'Preencha o campo';
                        }
                        return null;
                      },
                      controller: nomeController,
                      textAlign: TextAlign.center,
                      decoration: myDecoration('Nome Completo'),
                    ),
                  ),
                  Padding(
                    padding: paddingPadraoFormulario,
                    child: TextFormField(
                      validator: (String? value) {
                        if (valueValidator(value)) {
                          return 'Preencha o campo';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: cpfController,
                      textAlign: TextAlign.center,
                      decoration: myDecoration('CPF'),
                    ),
                  ),
                  Padding(
                    padding: paddingPadraoFormulario,
                    child: ValueListenableBuilder(
                      valueListenable: dropCargoValue,
                      builder: (BuildContext context, String value, _) {
                        return DropdownButtonFormField<String>(
                            validator: (value) {
                              return (value == null)
                                  ? 'Campo obrigatório!'
                                  : null;
                            },
                            isExpanded: true,
                            hint: const Text('Selecione'),
                            decoration: myDecoration('*Cargo'),
                            value: (value.isEmpty) ? null : value,
                            items: Cargo.getAll()
                                .map(
                                  (op) => DropdownMenuItem(
                                    value: op.codigo.toString(),
                                    child: Text(
                                      op.descricao,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (escolha) {
                              dropCargoValue.value = escolha.toString();
                            });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Adicionar foto'),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    // Defina o raio dos cantos
                    child: Image.asset(
                      'images/nophoto.png',
                      height: 200,
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      setState(() {});
                      if (_formKey.currentState!.validate()) {
                        print(
                            '${nomeController.text} ${cpfController.text} ${int.parse(dropCargoValue.value)} ');
                        FuncionarioDao().save(Funcionario(
                          nomeController.text,
                          cpfController.text,
                          int.parse(dropCargoValue.value), //
                          //imagemController.text
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Salvando registro!'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Salvar!'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
