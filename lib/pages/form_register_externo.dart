import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/foto.dart';

import '../model/enum_tipo_paciente.dart';
import '../model/externo.dart';
import '../util/banco.dart';
import '../util/constants.dart';

class FormCadastroExterno extends StatefulWidget {
  final BuildContext externoContext;
  final Externo? externoEdit;
  final String tipoCadastro;

  const FormCadastroExterno(
      {super.key,
      required this.externoContext,
      this.externoEdit,
      required this.tipoCadastro});

  @override
  State<FormCadastroExterno> createState() => _FormCadastroExternoState();
}

class _FormCadastroExternoState extends State<FormCadastroExterno> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final imageController = TextEditingController();
  final dropTipoPacienteValue = ValueNotifier('');
  final dropAreaValue = ValueNotifier('');
  String? _imageUrl;

  List<String> tiposCadastrosMenu = [
    'Funcionário',
    'Paciente',
    'Acompanhante/Visitante',
    'Temporário',
    'Equipamento'
  ];

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
    if (widget.externoEdit != null) {
      setState(() {
        nomeController.text = widget.externoEdit!.nome;
        cpfController.text = widget.externoEdit!.cpf;
        //dropAreaValue.value = widget.externoEdit!.area;
        dropTipoPacienteValue.value = widget.externoEdit!.tipoPaciente!;
        _imageUrl = widget.externoEdit!.foto;
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
                  ),
                ),
                (widget.tipoCadastro != tiposCadastrosMenu[1])? nada:
                Padding(
                  padding: paddingPadraoFormulario,
                  child: ValueListenableBuilder(
                    valueListenable: dropTipoPacienteValue,
                    builder: (BuildContext context, String value, _) {
                      return DropdownButtonFormField<String>(
                          validator: (value) {
                            return (value == null)
                                ? 'Campo obrigatório!'
                                : null;
                          },
                          isExpanded: true,
                          hint: const Text('Selecione'),
                          decoration: myDecoration('*Tipo de Paciente'),
                          value: (value.isEmpty) ? null : value,
                          items: TipoPaciente.getAll()//alterar
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
                            dropTipoPacienteValue.value = escolha.toString();
                          });
                    },
                  ),
                ),
                //N O V O
                (widget.externoEdit?.id != null)
                    ? Foto(
                        uUID: widget.externoEdit!.id,
                        imageUrl: _imageUrl,
                        onUpload: (imageUrl) async {
                          setState(() {
                            _imageUrl = imageUrl;
                            print(_imageUrl);
                          });
                          final userId = widget.externoEdit!.id;
                          print(userId);
                          await supabase
                              .from('funcionario')
                              .update({'foto': imageUrl}).eq('id', userId!);
                          print(_imageUrl);
                          print(userId);
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
                          '${nomeController.text} ${cpfController.text} ${dropTipoPacienteValue.value} \n$_imageUrl');
                      ExternoDao().save(Externo(
                        nomeController.text,
                        cpfController.text,
                        widget.tipoCadastro,
                        dropTipoPacienteValue.value,
                        //_imageUrl,
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
