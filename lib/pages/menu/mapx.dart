import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/map_explorer.dart';
import 'package:projeto_ble_renew/components/map_locale.dart';

class MenuMapa extends StatefulWidget {
  const MenuMapa({super.key});

  @override
  State<MenuMapa> createState() => _MenuMapaState();
}

class _MenuMapaState extends State<MenuMapa> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Tab(
                  icon: Icon(Icons.location_searching),
                  text: 'Mapa de Localização'),
              Tab(icon: Icon(Icons.travel_explore), text: 'Mapa Exploratório'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            MapLocale(),
            MapExplorer(),
          ],
        ),
      ),
    );
  }
}
