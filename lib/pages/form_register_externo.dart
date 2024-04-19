import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/foto.dart';
import 'package:projeto_ble_renew/model/pessoa.dart';
import 'package:projeto_ble_renew/util/app_cores.dart';
import 'package:uuid/uuid.dart';
import '../model/area.dart';
import '../model/enum_tipo_paciente.dart';
import '../model/externo.dart';
import '../util/constants.dart';
import '../util/formatters.dart';
import 'pesquisa.dart';

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
  final pacienteController = TextEditingController();
  final dropTipoPacienteValue = ValueNotifier('');
  final dropAreaValue = ValueNotifier('');
  String? _imageUrl;
  bool isEditar = false;
  var uuid = const Uuid();
  List<bool> isSwitched = [true, false];
  String areaDestino = '';
  Externo? pacienteTemp;

  List<String> tiposCadastrosMenu = [
    'Funcionário',
    'Paciente',
    'Acompanhante/Visitante',
    'Temporário',
    'Equipamento'
  ];

  @override
  void initState() {
    pessoaSelecionadaX == null;
    super.initState();
    _seEditar();
  }

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    pacienteController.dispose();
    pessoaSelecionadaX == null;
    _imageUrl = '';
    super.dispose();
  }

  void _seEditar() async {
    if (widget.tipoCadastro == tiposCadastrosMenu[2]) {
      if (widget.externoEdit!.paciente == null) {
        pacienteController.text = '';
      } else {
        pessoaSelecionadaX =
            await PessoaDao().findID(widget.externoEdit!.paciente!);
        pacienteController.text = pessoaSelecionadaX.toString();
        pacienteTemp = await ExternoDao().findID(pessoaSelecionadaX!.id!);
        areaDestino = Area.getNomeById(pacienteTemp!.area!);
      }
    }
    if (widget.externoEdit != null) {
      setState(() {
        nomeController.text = widget.externoEdit!.nome;
        cpfController.text = widget.externoEdit!.cpf;
        dropAreaValue.value = widget.externoEdit!.area.toString();
        dropTipoPacienteValue.value = widget.externoEdit!.tipoPaciente!;
        _imageUrl = widget.externoEdit!.foto;
        isEditar = true;
      });
    }
  }

  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }

  String _tipoExterno() {
    if (widget.tipoCadastro == tiposCadastrosMenu[1]) {
      return tiposCadastrosMenu[1];
    } else if (widget.tipoCadastro == tiposCadastrosMenu[3]) {
      return tiposCadastrosMenu[3];
    } else {
      if (isSwitched[0] == true) {
        return 'Visitante';
      } else {
        return 'Acompanhante';
      }
    }
  }

  void _verifica() {
    setState(() {
      pacienteController.text =
          (pessoaSelecionadaX == null) ? '' : pessoaSelecionadaX.toString();
      if (pacienteTemp != null) {
        areaDestino = Area.getNomeById(pacienteTemp!.area!);
      }
    });
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
                space,
                (widget.tipoCadastro == tiposCadastrosMenu[1] ||
                        (widget.tipoCadastro == tiposCadastrosMenu[3]))
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
                (widget.tipoCadastro == tiposCadastrosMenu[2])
                    ? Padding(
                        padding: paddingPadraoFormulario,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.77,
                              child: TextFormField(
                                key: const ValueKey('paciente'),
                                controller: pacienteController,
                                validator: (value) {
                                  return (value == null || value.isEmpty)
                                      ? 'Preencha este campo'
                                      : null;
                                },
                                decoration: myDecoration('Paciente'),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Pesquisa(
                                              param: 'externo'))).then((value) async {
                                    _verifica();
                                    pacienteTemp = await ExternoDao().findID(pessoaSelecionadaX!.id!);
                                    areaDestino = Area.getNomeById(pacienteTemp!.area!);
                                    setState(() {});
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                                child: const Icon(Icons.search))
                          ],
                        ),
                      )
                    : Padding(
                        padding: paddingPadraoFormulario,
                        child: ValueListenableBuilder(
                          valueListenable: dropAreaValue,
                          builder: (BuildContext context, String value, _) {
                            return DropdownButtonFormField<String>(
                                enableFeedback: false,
                                validator: (value) {
                                  return (value == null)
                                      ? 'Campo obrigatório!'
                                      : null;
                                },
                                isExpanded: true,
                                hint: const Text('Selecione'),
                                decoration: myDecoration('Setor/Zona/Área'),
                                value: (value.isEmpty) ? null : value,
                                items: Area.getAll()
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
                                  dropAreaValue.value = escolha.toString();
                                });
                          },
                        ),
                      ),
                (widget.tipoCadastro == tiposCadastrosMenu[2])
                    ? Text(
                        areaDestino,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: verdeBotao,
                            fontSize: 18),
                      )
                    : nada,
                Foto(
                    uUID: (isEditar) ? widget.externoEdit?.id : uuid.v1(),
                    imageUrl: _imageUrl,
                    onUpload: (imageUrl) async {
                      if (!mounted) return;
                      setState(() {
                        _imageUrl = imageUrl;
                      });
                    }),
                space,
                FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                       ExternoDao()
                          .save(Externo(
                        nome: nomeController.text,
                        cpf: cpfController.text,
                        tipoExterno: _tipoExterno(),
                        tipoPaciente: dropTipoPacienteValue.value,
                        paciente: pessoaSelecionadaX?.id,
                        area: int.parse(dropAreaValue.value),
                        foto: (_imageUrl != '') ? _imageUrl : '',
                      ))
                          .then((value) {
                        Navigator.pop(context, value);
                      });
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
