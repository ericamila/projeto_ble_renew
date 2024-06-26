import 'package:flutter/material.dart';
import 'package:supabase/src/supabase_stream_builder.dart';
import '../../components/alarme_list_tile.dart';
import '../../util/banco.dart';
import '../../util/constants.dart';

class MenuAlarme extends StatefulWidget {
  const MenuAlarme({super.key});

  @override
  State<MenuAlarme> createState() => _MenuAlarmeState();
}

class _MenuAlarmeState extends State<MenuAlarme> {
  final _stream = supabase
      .from('tb_registro_alarmes_new')
      .stream(primaryKey: ['id']).eq('closed', 'false');

  @override
  Widget build(BuildContext context) {
    var stream = StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Expanded(child: Center(child: carregando));
            case ConnectionState.active:
            case ConnectionState.done:
              SupabaseStreamEvent? querySnapshot = snapshot.data;

              if (snapshot.hasError) {
                return const Expanded(child: Text("Erro ao carregar dados!"));
              } else {

                if (querySnapshot!.isEmpty) {
                  return noData();
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: querySnapshot.length,
                    itemBuilder: (context, index) {
                      List<Map<String, dynamic>> alarmes =
                          querySnapshot.toList();

                      if (alarmes.isEmpty) {
                        return noData();
                      }

                      var item = alarmes[index];

                      return AlarmeListTile(alarme: item);
                    },
                  ),
                );
              }
          }
        });

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/app_icon.ico'),
            fit: BoxFit.cover,
            opacity: 0.06),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              stream,
            ],
          ),
        ),
      ),
    );
  }
}
