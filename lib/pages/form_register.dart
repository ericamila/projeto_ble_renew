import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/funcionario.dart';

class FormCadastro extends StatefulWidget {
  final BuildContext funcionarioContext;
  final Funcionario? funcionarioEdit;

  const FormCadastro(
      {super.key, required this.funcionarioContext, this.funcionarioEdit});

  @override
  State<FormCadastro> createState() => _FormCadastroState();
}

class _FormCadastroState extends State<FormCadastro> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController imagemController = TextEditingController();

  //radiobutton para tipo
  //dropbutton para cargo

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
    }
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
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
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (String? value) {
                        if (valueValidator(value)) {
                          return 'Preencha o campo';
                        }
                        return null;
                      },
                      controller: nomeController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Nome',
                        fillColor: Colors.white70,
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'CPF',
                        fillColor: Colors.white70,
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 72,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.blue),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imagemController.text,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset('images/nophoto.png');
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FuncionarioDao().save(Funcionario(
                            nomeController.text,
                            cpfController.text,
                            'Funcionário', //apagar
                            1, //apagar
                            //imagemController.text
                            //int.parse(difficultyController.text)
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
