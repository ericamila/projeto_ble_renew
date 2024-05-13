import 'package:flutter/material.dart';
import '../../components/alarme_list_tile.dart';
import '../../util/banco.dart';
import '../../util/constants.dart';

class MenuAlarme extends StatefulWidget {
  const MenuAlarme({super.key});

  @override
  State<MenuAlarme> createState() => _MenuAlarmeState();
}

class _MenuAlarmeState extends State<MenuAlarme> {
  Future<List<Map<String, dynamic>>> _instanceDB() async {
    return await supabase.from('vw_registro_alarmes').select();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(//colocar backgoorund
        constraints: const BoxConstraints(
          maxWidth: 600.0,
        ),
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _instanceDB(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final alarmes = snapshot.data!;
            if (alarmes.isEmpty) {
              return noData();
            }
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
