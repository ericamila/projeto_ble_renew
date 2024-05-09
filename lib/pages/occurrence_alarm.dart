import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/extensions.dart';
import 'package:projeto_ble_renew/model/funcionario.dart';
import 'package:projeto_ble_renew/util/app_cores.dart';
import 'package:projeto_ble_renew/util/constants.dart';

import '../model/externo.dart';

class OcurrenceAlarme extends StatefulWidget {
  final Map<String, dynamic> alarme;

  const OcurrenceAlarme({super.key, required this.alarme});

  @override
  State<OcurrenceAlarme> createState() => _OcurrenceAlarmeState();
}

class _OcurrenceAlarmeState extends State<OcurrenceAlarme> {
  bool light = false;
  String _image = imagemPadraoNetwork;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    _updateImage();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ocorrência'),
      ),
      body: SingleChildScrollView(
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
                        color: (!light) ? Colors.red[800] : verdeBotao),
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: TextField(
                  minLines: 5,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Detalhamento da ocorrência",
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  debugPrint('Salvei o registro não!');
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
}
