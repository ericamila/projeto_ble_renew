import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/extensions.dart';
import 'package:projeto_ble_renew/util/app_cores.dart';
import 'package:projeto_ble_renew/util/constants.dart';

class OcurrenceAlarme extends StatefulWidget {
  final Map<String, dynamic> alarme;

  const OcurrenceAlarme({super.key, required this.alarme});

  @override
  State<OcurrenceAlarme> createState() => _OcurrenceAlarmeState();
}

class _OcurrenceAlarmeState extends State<OcurrenceAlarme> {
  bool light = true;

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
                padding: EdgeInsets.symmetric(vertical: 24),
                child: TextField(
                  maxLines: 6,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Detalhamento da condução da ocorrência",
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
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textoFormatado(
                      'Data',
                      DateTime.parse(widget.alarme['data_hora'])
                          .formatBrazilianDate),
                  textoFormatado(
                      'Hora',
                      DateTime.parse(widget.alarme['data_hora'])
                          .formatBrazilianTime),
                  textoFormatado('Local', widget.alarme['area']),
                  textoFormatado('Usuário', widget.alarme['nome']),
                  textoFormatado('Códico do alarme',
                      '${widget.alarme['codigo']} - ${widget.alarme['alarme']}',
                      alinhamento: TextAlign.start),
                ],
              ),

              //Image.network(''),
            ],
          ),
        ),
      ),
    );
  }
}
