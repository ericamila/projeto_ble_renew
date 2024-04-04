import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/foto.dart';

import '../model/area.dart';
import '../model/enum_tipo_paciente.dart';
import '../model/externo.dart';
import '../util/banco.dart';
import '../util/constants.dart';
import '../util/formatters.dart';

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
  late List<Area> listArea = [];
  List<bool> isSwitched = [true, false];

  List<String> tiposCadastrosMenu = [
    'Funcionário',
    'Paciente',
    'Acompanhante/Visitante',
    'Temporário',
    'Equipamento'
  ];

  @override
  void initState() {
    _carregaDrop();
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
        //dropAreaValue.value = widget.externoEdit!.area; alterar
        dropTipoPacienteValue.value = widget.externoEdit!.tipoPaciente!;
        _imageUrl = widget.externoEdit!.foto;
      });
    }
  }

  _carregaDrop() async {
    List listaTemp = [];
    List data = await supabase.from('area').select();
    setState(() {
      listaTemp.addAll(data);
    });
    for (var i in listaTemp) {
      listArea.add(Area.fromMap(i));
    }
    setState(() {});
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
                (widget.tipoCadastro == tiposCadastrosMenu[1])
                    ? nada
                    : Center(
                        child: ToggleButtons(
                            constraints: BoxConstraints(
                                minHeight: 45, //alterar
                                minWidth:
                                    MediaQuery.of(context).size.width * 0.35),
                            isSelected: isSwitched,
                            onPressed: (index) {
                              setState(() {
                                isSwitched[0] = !isSwitched[0];
                                isSwitched[1] = !isSwitched[1];
                              });
                            },
                            children: const [
                              Text('Visisante',
                                  style: TextStyle(
                                      fontSize: sizeFontToggleButtons)),
                              Text('Acompanhante',
                                  style: TextStyle(
                                      fontSize: sizeFontToggleButtons)),
                            ]),
                      ),
                space,
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
                (widget.tipoCadastro != tiposCadastrosMenu[1])
                    ? nada
                    : Padding(
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
                                items: TipoPacienteEnum.getAll() //alterar
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
                                  dropTipoPacienteValue.value =
                                      escolha.toString();
                                });
                          },
                        ),
                      ),
                Padding(
                  padding: paddingPadraoFormulario,
                  child: ValueListenableBuilder(
                    valueListenable: dropAreaValue,
                    builder: (BuildContext context, String value, _) {
                      return DropdownButtonFormField<String>(
                          validator: (value) {
                            return (value == null)
                                ? 'Campo obrigatório!'
                                : null;
                          },
                          isExpanded: true,
                          hint: const Text('Selecione'),
                          decoration: myDecoration('Setor/Zona/Área'),
                          value: (value.isEmpty) ? null : value,
                          items: listArea
                              .map(
                                (op) => DropdownMenuItem(
                                  value: op.id.toString(),
                                  child: Text(
                                    op.descricao,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (escolha) {
                            dropAreaValue.value = escolha.toString();
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
                              .from('externo')
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
                        (isSwitched[0] == true) ? 'Visitante' : 'Acompanhante',
                        dropTipoPacienteValue.value,
                        (_imageUrl != '') ? _imageUrl : '',
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
