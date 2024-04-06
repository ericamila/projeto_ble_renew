import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/foto.dart';
import 'package:projeto_ble_renew/model/funcionario.dart';
import '../model/cargo.dart';
import '../util/banco.dart';
import '../util/constants.dart';
import '../util/formatters.dart';

class FormCadastroFuncionario extends StatefulWidget {
  final BuildContext funcionarioContext;
  final Funcionario? funcionarioEdit;
  final String tipoCadastro;

  const FormCadastroFuncionario(
      {super.key,
      required this.funcionarioContext,
      this.funcionarioEdit,
      required this.tipoCadastro});

  @override
  State<FormCadastroFuncionario> createState() =>
      _FormCadastroFuncionarioState();
}

class _FormCadastroFuncionarioState extends State<FormCadastroFuncionario> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final imageController = TextEditingController();
  final dropCargoValue = ValueNotifier('');
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _seEditar();
  }

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    super.dispose();
  }

  void _seEditar() {
    if (widget.funcionarioEdit != null) {
      setState(() {
        nomeController.text = widget.funcionarioEdit!.nome;
        cpfController.text = widget.funcionarioEdit!.cpf;
        dropCargoValue.value = widget.funcionarioEdit!.cargo.toString();
        _imageUrl = widget.funcionarioEdit!.foto;
      });
    }
  }

  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cadastro de ${widget.tipoCadastro}'),
        ),
        body: Center(
          child: SingleChildScrollView(
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
                    inputFormatters: [cpfFormatter],
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
                //N O V O
                (widget.funcionarioEdit?.id != null)
                    ? Foto(
                        uUID: widget.funcionarioEdit!.id,
                        imageUrl: _imageUrl,
                        onUpload: (imageUrl) async {
                          setState(() {
                            _imageUrl = imageUrl;
                          });
                          final userId = widget.funcionarioEdit!.id;
                          await supabase
                              .from('funcionario')
                              .update({'foto': imageUrl}).eq('id', userId!);
                        })
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          color: Colors.grey,
                          child: Image.asset('images/nophoto.png', height: 200),
                        ),
                      ),
                //FotoImagem(),
                space,
                FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(
                          '${nomeController.text} ${cpfController.text} ${int.parse(dropCargoValue.value)} \n$_imageUrl');
                      FuncionarioDao().save(Funcionario(
                        nome: nomeController.text,
                        cpf: cpfController.text,
                        cargo: int.parse(dropCargoValue.value),
                        foto: (_imageUrl != '') ? _imageUrl : '',
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
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
