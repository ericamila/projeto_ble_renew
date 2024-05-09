import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/dispositivo.dart';

import '../../components/my_list_tile.dart';
import '../../util/constants.dart';

class ListarDispositivos extends StatefulWidget {
  const ListarDispositivos({super.key});

  @override
  State<ListarDispositivos> createState() => _ListarDispositivosState();
}

class _ListarDispositivosState extends State<ListarDispositivos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listar Dispositivos'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder<List<Dispositivo>>(
          future: DispositivoDao().findAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final dispositivos = snapshot.data!;
            if (dispositivos.isEmpty) {
              return noData();
            }
            return ListView.builder(
              itemCount: dispositivos.length,
              itemBuilder: ((context, index) {
                final dispositivo = dispositivos[index];
                return MyListTile(
                  onTap: () {},
                  icon: (dispositivo.status!)
                      ? Icons.bluetooth
                      : Icons.bluetooth_disabled,
                  text: 'TAG: ${dispositivo.tag} - Tipo: ${dispositivo.tipo}'
                      '\nMAC: ${dispositivo.mac} \nStatus: ${dispositivo.status}',
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
