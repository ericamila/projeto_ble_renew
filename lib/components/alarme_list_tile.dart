import 'package:flutter/material.dart';


class AlarmeListTile extends StatelessWidget {
  final Map<String, dynamic> alarme;

  const AlarmeListTile({
    super.key,
    required this.alarme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 5, 14, 0),
      child: ListTile(
          leading: const Icon(Icons.notifications_active),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
          title: Text('${alarme['data_hora'].toString()} - ${alarme['id'].toString()}'),
          onTap: null),
    );
  }
}
