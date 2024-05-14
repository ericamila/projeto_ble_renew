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
  @override
  Widget build(BuildContext context) {
    var stream = StreamBuilder(
        stream: supabase.from('vw_registro_alarmes').select().asStream(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Expanded(child: Center(child: CircularProgressIndicator()));
            case ConnectionState.active:
            case ConnectionState.done:
              var querySnapshot = snapshot.data;

              if (snapshot.hasError) {
                return const Expanded(child: Text("Erro ao carregar dados!"));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: querySnapshot?.length,
                    itemBuilder: (context, index) {

                      List<Map<String, dynamic>> alarmes =
                          querySnapshot!.toList();

                      if (alarmes.isEmpty) {
                        return noData();
                      }

                      var item = alarmes[index];
                      return AlarmeListTile(alarme: item);
                      //return Text(item['codigo']);/
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
            image: AssetImage('images/web_hi_res_512.png'),
            fit: BoxFit.cover,
            opacity: 0.2),
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
