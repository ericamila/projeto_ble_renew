import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/foto.dart';
import 'package:projeto_ble_renew/util/constants.dart';
import 'package:uuid/uuid.dart';
import '../../model/enum_tipo_equipamento.dart';
import '../../model/equipamento.dart';

class FormCadastroEquipamento extends StatefulWidget {
  final BuildContext equipamentoContext;
  final Equipamento? equipamentoEdit;
  final String tipoCadastro;

  const FormCadastroEquipamento(
      {super.key,
      required this.equipamentoContext,
      this.equipamentoEdit,
      required this.tipoCadastro});

  @override
  State<FormCadastroEquipamento> createState() =>
      _FormCadastroEquipamentoState();
}

class _FormCadastroEquipamentoState extends State<FormCadastroEquipamento> {
  final _formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final codigoController = TextEditingController();
  final imageController = TextEditingController();
  final dropTipoValue = ValueNotifier('');
  String? _imageUrl;
  bool isEditar = false;
  var uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _seEditar();
  }

  @override
  void dispose() {
    descricaoController.dispose();
    codigoController.dispose();
    _imageUrl = '';
    super.dispose();
  }

  void _seEditar() {
    if (widget.equipamentoEdit != null) {
      setState(() {
        descricaoController.text = widget.equipamentoEdit!.descricao;
        codigoController.text = widget.equipamentoEdit!.codigo;
        dropTipoValue.value = widget.equipamentoEdit!.tipo;
        _imageUrl = widget.equipamentoEdit!.foto;
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
                    controller: descricaoController,
                    textAlign: TextAlign.center,
                    decoration: myDecoration('Descrição'),
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
                    controller: codigoController,
                    textAlign: TextAlign.center,
                    decoration: myDecoration('Código'),
                  ),
                ),
                Padding(
                  padding: paddingPadraoFormulario,
                  child: ValueListenableBuilder(
                    valueListenable: dropTipoValue,
                    builder: (BuildContext context, String value, _) {
                      return DropdownButtonFormField<String>(
                          validator: (value) {
                            return (value == null)
                                ? 'Campo obrigatório!'
                                : null;
                          },
                          isExpanded: true,
                          hint: const Text('Selecione'),
                          decoration: myDecoration('Tipo'),
                          value: (value.isEmpty) ? null : value,
                          items: TipoEquipamentoEnum.getAll()
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
                            dropTipoValue.value = escolha.toString();
                          });
                    },
                  ),
                ),
                Foto(
                    uUID: (isEditar) ? widget.equipamentoEdit?.id : uuid.v1(),
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
                      _register().then((value) {
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

  Future<bool> _register() async {
    try {
      EquipamentoDao().save(Equipamento(
        descricao: descricaoController.text,
        tipo: dropTipoValue.value,
        codigo: codigoController.text,
        foto: (_imageUrl != '') ? _imageUrl : '',
      ));
      return true;
    } catch (error) {
      return false;
    }
  }
}
