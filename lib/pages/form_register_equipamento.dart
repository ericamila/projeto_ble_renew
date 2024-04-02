import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/foto.dart';

import '../model/enum_tipo_equipamento.dart';
import '../model/equipamento.dart';
import '../util/banco.dart';
import '../util/constants.dart';

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
  State<FormCadastroEquipamento> createState() => _FormCadastroEquipamentoState();
}

class _FormCadastroEquipamentoState extends State<FormCadastroEquipamento> {
  final _formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final codigoController = TextEditingController();
  final imageController = TextEditingController();
  final dropTipoValue = ValueNotifier('');
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _seEditar();
  }

  @override
  void dispose() {
    descricaoController.dispose();
    codigoController.dispose();
    super.dispose();
  }

  void _seEditar() {
    if (widget.equipamentoEdit != null) {
      setState(() {
        descricaoController.text = widget.equipamentoEdit!.descricao;
        codigoController.text = widget.equipamentoEdit!.codigo;
        dropTipoValue.value = widget.equipamentoEdit!.tipo;
        _imageUrl = widget.equipamentoEdit!.foto;
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
                //N O V O
                (widget.equipamentoEdit?.id != null)
                    ? Foto(
                        uUID: widget.equipamentoEdit!.id,
                        imageUrl: _imageUrl,
                        onUpload: (imageUrl) async {
                          setState(() {
                            _imageUrl = imageUrl;
                            print(_imageUrl);
                          });
                          final userId = widget.equipamentoEdit!.id;
                          print(userId);
                          await supabase
                              .from('equipamento')
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
                          '${descricaoController.text}  ${dropTipoValue.value} ${codigoController.text} \n$_imageUrl');
                      EquipamentoDao().save(Equipamento(
                        descricaoController.text,
                        dropTipoValue.value,
                        codigoController.text,
                        (_imageUrl != '')? _imageUrl :'',
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
