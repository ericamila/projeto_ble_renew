import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/extensions.dart';

import '../model/registro_movimentacao.dart';

class AlarmeListTile extends StatelessWidget {
  //final Map<String, dynamic> alarme;
  final Movimento alarme;

  const AlarmeListTile({
    super.key,
    required this.alarme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 5, 14, 0),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.notifications_active),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
          title: Text(
              '${alarme.dataHora.FormatBrazilianDate} - ${alarme.dataHora.FormatBrazilianTime}'),
          subtitle: Text(
              'alarme: ${alarme.alarme} - Dispositivo: ${alarme.dispositivo} \nLocal: ${alarme.raspberry}'),
          onTap: () {},
        ),
      ),
    );
  }
}
