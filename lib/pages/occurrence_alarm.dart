import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/extensions.dart';
import 'package:projeto_ble_renew/model/funcionario.dart';
import 'package:projeto_ble_renew/util/app_cores.dart';
import 'package:projeto_ble_renew/util/constants.dart';

import '../components/foto_registro_alarme.dart';
import '../model/externo.dart';
import '../util/banco.dart';

class OcurrenceAlarme extends StatefulWidget {
  final Map<String, dynamic> alarme;

  const OcurrenceAlarme({super.key, required this.alarme});

  @override
  State<OcurrenceAlarme> createState() => _OcurrenceAlarmeState();
}

class _OcurrenceAlarmeState extends State<OcurrenceAlarme> {
  bool light = false;
  String _image = imagemPadraoNetwork;
  final TextEditingController _detailsController = TextEditingController();
  final _formKeyT = GlobalKey<FormState>();
  String foto = '';
  String fotoOcorrencia = '';
  Color corFoto = Colors.black87;

  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  void initState() {
    _updateDetails();
    _updateImage();
    super.initState();
  }

  void _updateDetails() {
    if (widget.alarme['descricao'] != null) {
      _detailsController.text = widget.alarme['descricao'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ocorrência'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKeyT,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ocorrência ${(!light) ? 'pendente!' : 'encerrada!'}',
                      style: TextStyle(
                          fontSize: 18,
                          color: (!light)
                              ? Colors.red[800]
                              : AppColors.verdeBotao),
                    ),
                    space,
                    Switch(
                      thumbIcon: thumbIcon,
                      value: light,
                      onChanged: (bool value) {
                        setState(() {
                          light = value;
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    controller: _detailsController,
                    validator: (String? value) {
                      if (valueValidator(value)) {
                        return 'Preencha o campo';
                      }
                      return null;
                    },
                    minLines: 5,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(),
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: "Detalhamento da ocorrência",
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FotoAlarme(id: widget.alarme['id'].toString()),
                        )).then((value) {
                      setState(() {
                        fotoOcorrencia = value ?? '';
                        print('fotoocorrencia $fotoOcorrencia');
                        foto = 'foto.png';
                        corFoto = Colors.blueAccent;
                      });
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Anexar foto: (opcional)'),
                        Text(foto),
                        Icon(
                          Icons.attach_file,
                          color: corFoto,
                        ),
                      ],
                    ),
                  ),
                ),
                space,
                FilledButton(
                  onPressed: () {
                    if (_formKeyT.currentState!.validate()) {
                      _salvarRegistro().then((value) {
                        (value == true)
                            ? showSnackBarDefault(context)
                            : showSnackBarDefault(context,
                                message: "Houve uma falha ao registar.");
                        //verificar se retorna para home
                        if (value == true) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      });
                    }
                  },
                  child: const Text('Salvar'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textoFormatado('Códico do alarme',
                        '${widget.alarme['codigo']} - ${widget.alarme['alarme']}',
                        alinhamento: TextAlign.start),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textoFormatado(
                            'Data',
                            DateTime.parse(widget.alarme['data_hora'])
                                .formatBrazilianDate),
                        textoFormatado(
                            'Hora',
                            DateTime.parse(widget.alarme['data_hora'])
                                .formatBrazilianTime),
                      ],
                    ),
                    textoFormatado('Local', widget.alarme['area']),
                    textoFormatado('Usuário', widget.alarme['nome']),
                    spaceMenor,
                    Center(child: imagemClipRRect(_image, size: 150)),
                    Center(
                        child: textoFormatado(
                            'Tipo', widget.alarme['tipo_externo'])),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateImage() async {
    widget.alarme['tipo_externo'];
    if ('Funcionário' == widget.alarme['tipo_externo']) {
      Funcionario funci =
          await FuncionarioDao().findID(widget.alarme['id_pessoa']);
      if (funci.foto != null) {
        _image = funci.foto!;
      }
    } else {
      Externo externo = await ExternoDao().findID(widget.alarme['id_pessoa']);
      if (externo.foto != null) {
        _image = externo.foto!;
      }
    }
    mounted ? setState(() {}) : carregando;
  }

  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> _salvarRegistro() async {
    try {
      await supabase
          .from('tb_registro_alarmes_new')
          .update({'closed': light, 'descricao': _detailsController.text, 'foto': fotoOcorrencia}).eq(
              'id', widget.alarme['id']);
      return true;
    } catch (error) {
      return false;
    }
  }
}
