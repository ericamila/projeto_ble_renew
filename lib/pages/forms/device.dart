import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/dispositivo.dart';
import 'package:projeto_ble_renew/util/formatters.dart';
import '../../model/enum_tipo_dispositivo.dart';
import '../../util/constants.dart';

class FormCadastroDispositivo extends StatefulWidget {
  final String? atualiza;

  const FormCadastroDispositivo({super.key, this.atualiza});

  @override
  State<FormCadastroDispositivo> createState() =>
      _FormCadastroDispositivoState();
}

class _FormCadastroDispositivoState extends State<FormCadastroDispositivo> {
  final _formKey = GlobalKey<FormState>();
  final tagController = TextEditingController();
  final macController = TextEditingController();
  bool isEnable = false;
  TipoDispositivoEnum? _tipo = TipoDispositivoEnum.pulseira;
  List<bool> isSwitched = [true, false];
  final _status = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tagController.dispose();
    macController.dispose();
    deviceNomeBLE = '';
    super.dispose();
  }

  //Habilita o TextFormField da TAG
  void _verifica() {
    isEnable = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Dispositivo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: ToggleButtons(
                    constraints: BoxConstraints(
                        minHeight: 45, //alterar
                        minWidth: MediaQuery.of(context).size.width * 0.35),
                    isSelected: isSwitched,
                    onPressed: (index) {
                      setState(() {
                        isSwitched[0] = !isSwitched[0];
                        isSwitched[1] = !isSwitched[1];
                        isEnable = !isEnable;
                      });
                    },
                    children: const [
                      Text('Automático', style: TextStyle(fontSize: 17)),
                      Text('Manual', style: TextStyle(fontSize: 17)),
                    ]),
              ),
              (isSwitched[0])
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Escanear Dispositivo'),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/bluetooth').then(
                              (value) {
                                if (value != null) {
                                  macController.text = value.toString();
                                  _verifica();
                                }
                              },
                            );
                          },
                          child: const Text('Escanear'),
                        ),
                      ],
                    )
                  : TextFormField(
                      key: const ValueKey('mac'),
                      controller: macController,
                      validator: (value) {
                        return (value == null || value.isEmpty)
                            ? 'Preencha este campo'
                            : null;
                      },
                      decoration: myDecoration('MAC'),
                      inputFormatters: [macFormatter],
                      textCapitalization: TextCapitalization.characters),
              space,
              if (isSwitched[0]) Text(macController.text),
              space,
              TextFormField(
                  key: const ValueKey('tag'),
                  controller: tagController,
                  enabled: (isSwitched[1]) ? true : isEnable,
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? 'Preencha este campo'
                        : null;
                  },
                  decoration: myDecoration('TAG'),
                  textCapitalization: TextCapitalization.characters),
              ListTile(
                title: const Text('Pulseira'),
                leading: Radio<TipoDispositivoEnum>(
                  value: TipoDispositivoEnum.pulseira,
                  groupValue: _tipo,
                  onChanged: (TipoDispositivoEnum? value) {
                    setState(() {
                      _tipo = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Crachá'),
                leading: Radio<TipoDispositivoEnum>(
                  value: TipoDispositivoEnum.cracha,
                  groupValue: _tipo,
                  onChanged: (TipoDispositivoEnum? value) {
                    setState(() {
                      _tipo = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Etiqueta'),
                leading: Radio<TipoDispositivoEnum>(
                  value: TipoDispositivoEnum.etiqueta,
                  groupValue: _tipo,
                  onChanged: (TipoDispositivoEnum? value) {
                    setState(() {
                      _tipo = value;
                    });
                  },
                ),
              ),
              space,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processando dados')),
                      );

                      try {
                        DispositivoDao().save(Dispositivo(
                          nome: deviceNomeBLE,
                          tag: tagController.text,
                          tipo: _tipo!.descricao,
                          status: _status,
                          mac: macController.text,
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Cadastro realizado com sucesso!')),
                        );
                        //Limpa tudo e retorna
                        Navigator.pushReplacementNamed(context, '/form_device');
                      } on Error catch (e) {
                        debugPrint(e as String?);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro: $e')),
                        );
                      }
                    }
                    //Se salvar com sucesso, limpar campos
                  },
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var deviceNomeBLE = '';
