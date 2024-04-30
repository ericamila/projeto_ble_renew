import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/registro_movimentacao.dart';

import '../../components/alarme_list_tile.dart';
import '../../util/banco.dart';

class MenuAlarme extends StatefulWidget {
  const MenuAlarme({super.key});

  @override
  State<MenuAlarme> createState() => _MenuAlarmeState();
}

class _MenuAlarmeState extends State<MenuAlarme> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 600.0,
        ),
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder<List<Movimento>>(
          future: MovimentoDao().findAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final alarmes = snapshot.data!;
            return ListView.builder(
              itemCount: alarmes.length,
              itemBuilder: ((context, index) {
                final alarme = alarmes[index];
                return AlarmeListTile(alarme: alarme);
              }),
            );
          },
        ),
      ),
    );
  }
}
