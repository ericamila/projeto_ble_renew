import 'package:flutter/material.dart';

import '../util/app_cores.dart';
import '../util/constants.dart';
import '../util/formatters.dart';

class MenuPesquisa extends StatefulWidget {
  const MenuPesquisa({super.key});

  @override
  State<MenuPesquisa> createState() => _MenuPesquisaState();
}

class _MenuPesquisaState extends State<MenuPesquisa> {
  TextEditingController userCPFController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController deviceIdController = TextEditingController();
  TextEditingController deviceTagController = TextEditingController();
  TextEditingController deviceMacController = TextEditingController();

  List<bool> isSwitched = [true, false];

  _limpa() {
    setState(() {
      userCPFController.text = '';
      userNameController.text = '';
      deviceIdController.text = '';
      deviceTagController.text = '';
      deviceMacController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: ToggleButtons(
                    constraints: BoxConstraints(
                        minHeight: 45, //alterar
                        minWidth: MediaQuery.of(context).size.width * 0.35),
                    isSelected: isSwitched,
                    onPressed: (index) {
                      setState(() {
                        isSwitched[0] = !isSwitched[0];
                        isSwitched[1] = !isSwitched[1];
                      });
                    },
                    children: const [
                      Text('Usuário', style: TextStyle(fontSize: 17)),
                      Text('Dispositivo', style: TextStyle(fontSize: 17)),
                    ]),
              ),
              spaceMenor,
              (isSwitched[0])
                  ? TextField(
                      controller: userCPFController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'CPF',
                        suffixIcon: Icon(Icons.search),
                      ),
                      inputFormatters: [cpfFormatter],
                    )
                  : TextField(
                      controller: deviceTagController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Tag',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
              spaceMenor,
              const Center(child: Text('ou')),
              (isSwitched[0])
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: userNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nome',
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                          controller: deviceMacController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'MAC Address',
                            suffixIcon: Icon(Icons.search),
                          ),
                          inputFormatters: [macFormatter]),
                    ),
              space,
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                ElevatedButton(
                  onPressed: () {
                    if (isSwitched[0]) {
                      if ((userCPFController.text != '') &&
                          (userNameController.text != '')) {
                        print('Escolha CPF ou Nome');
                      } else {
                        if (userCPFController.text != '') {
                          print('ver cpf');
                        } else if (userNameController.text != '') {
                          print('ver nome');
                        } else {
                          print('usuario invalido');
                        }
                      }
                    } else {
                      if ((deviceTagController.text != '') &&
                          (deviceMacController.text != '')) {
                        print('Escolha Tag ou MAC');
                      } else {
                        if (deviceTagController.text != '') {
                          print('ver mac');
                        } else if (deviceMacController.text != '') {
                          print('ver tag');
                        } else {
                          print('dispositivo invalido');
                        }
                      }
                    }
                  },
                  style: estiloSearchButton,
                  child: const Row(
                    children: [
                      Icon(Icons.search),
                      spaceMenor,
                      Text("Pesquisar"),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _limpa(),
                  style: estiloSearchButton,
                  child: const Row(children: [
                    Icon(Icons.refresh),
                    spaceMenor,
                    Text("Limpar")
                  ]),
                ),
              ]),
              space,
              const Text("Resultado:"),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: ListTile(title: Text('Resultado 1')),
              ),
            ]),
      ),
    );
  }
}
