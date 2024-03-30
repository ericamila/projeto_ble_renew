import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/pages/list_register.dart';

import '../components/my_filled_button.dart';
import '../util/constants.dart';
import 'drawer_list_usuario.dart';

class MenuCadastro extends StatefulWidget {
  const MenuCadastro({super.key});

  @override
  State<MenuCadastro> createState() => _MenuCadastroState();
}

class _MenuCadastroState extends State<MenuCadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyFlilledButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ListaCadastro(tipoCadastro: 'Funcionário',)));
              },
              text: 'Funcionário'),
          space,
          MyFlilledButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Usuarios()));
              },
              text: 'Usuario Temp')
        ],
      )),
    );
  }
}
