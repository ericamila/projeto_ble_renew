import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/funcionario.dart';
import 'package:projeto_ble_renew/pages/menu_search.dart';

import '../model/cargo.dart';
import '../util/app_cores.dart';
import '../util/my_theme.dart';
import 'menu_alarme.dart';
import 'menu_device.dart';
import 'menu_map.dart';
import 'menu_register.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;

  final List<Widget> _pages = [
    const MenuAlarme(),
    const MenuDispositivo(),
    const MenuPesquisa(),
    const MenuMapa(),
    const MenuCadastro(),
  ];

  void inserir() {
    var funci = Funcionario('Mônica Costa f', '20345814779', 'Funcionário', Cargo.tecnicoDeEnfermagem.codigo);
    FuncionarioDao dao = FuncionarioDao();
    //dao.save(funci);
    //dao.delete(20);
    //dao.findAll();
    //dao.find('20345814778');
  }

  @override
  Widget build(BuildContext context) {
    inserir();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Codelink"),
      ),
      //drawer: ,
      body: _pages[_page],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: claro,
        color: escuro,
        buttonBackgroundColor: verde,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        items: const [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home_outlined,
              color: claro,
            ),
            label: 'Início',
            labelStyle: estiloLabelCurvedBarItem,
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.bluetooth,
              color: claro,
            ),
            label: 'Dispositivos',
            labelStyle: estiloLabelCurvedBarItem,
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.search,
              color: claro,
            ),
            label: 'Busca',
            labelStyle: estiloLabelCurvedBarItem,
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.map_outlined,
              color: claro,
            ),
            label: 'Mapa',
            labelStyle: estiloLabelCurvedBarItem,
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.create_new_folder_outlined,
              color: claro,
            ),
            label: 'Cadastros',
            labelStyle: estiloLabelCurvedBarItem,
          ),
        ],
      ),
    );
  }
}
