import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/extensions.dart';
import 'package:projeto_ble_renew/pages/occurrence_alarm.dart';

import '../util/constants.dart';

class AlarmeListTile extends StatelessWidget {
  final Map<String, dynamic> alarme;

  const AlarmeListTile({
    super.key,
    required this.alarme,
  });

  @override
  Widget build(BuildContext context) {
    print('entrou');
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 5, 14, 0),
      child: Card(
        color: Colors.blueGrey[50],
        child: ListTile(
          leading: const Icon(Icons.notifications_active),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
          title: Text(
            '${DateTime.parse(alarme['data_hora']).formatBrazilianDate} - '
            '${DateTime.parse(alarme['data_hora']).formatBrazilianTime}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: RichText(
            text: TextSpan(
              text: '${alarme['codigo']} - ${alarme['alarme']} ',
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: '\n${alarme['area']}', style: respostaPerfil),
                TextSpan(text: '\n${alarme['nome']}'),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OcurrenceAlarme(alarme: alarme,)));
          }, //terminar
        ),
      ),
    );
  }
}
