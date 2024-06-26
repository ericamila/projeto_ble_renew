import 'package:flutter/material.dart';
import '../../components/my_filled_button.dart';
import '../list/list_equipment.dart';
import '../list/list_external.dart';
import '../list/list_employee.dart';


class MenuCadastro extends StatefulWidget {
  const MenuCadastro({super.key});

  @override
  State<MenuCadastro> createState() => _MenuCadastroState();
}

class _MenuCadastroState extends State<MenuCadastro> {
  List<String> tiposCadastrosMenu = [
    'Funcionário',
    'Paciente',
    'Acompanhante/Visitante',
    'Temporário',
    'Equipamento'
  ];

  @override
  Widget build(BuildContext context) {
    double myPadding = 15;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoas e Equipamentos'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: myPadding),
            child: MyFlilledButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListaCadastroFuncionario(
                              tipoCadastro: tiposCadastrosMenu[0])));
                },
                text: tiposCadastrosMenu[0]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: myPadding),
            child: MyFlilledButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListaCadastroExterno(
                              tipoCadastro: tiposCadastrosMenu[1])));
                },
                text: tiposCadastrosMenu[1]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: myPadding),
            child: MyFlilledButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListaCadastroExterno(
                              tipoCadastro: tiposCadastrosMenu[2])));
                },
                text: tiposCadastrosMenu[2]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: myPadding),
            child: MyFlilledButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListaCadastroExterno(
                              tipoCadastro: tiposCadastrosMenu[3])));
                },
                text: tiposCadastrosMenu[3]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: myPadding),
            child: MyFlilledButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListaCadastroEquipamento(
                              tipoCadastro: tiposCadastrosMenu[4])));
                },
                text: tiposCadastrosMenu[4]),
          ),
        ],
      )),
    );
  }
}
