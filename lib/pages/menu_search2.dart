import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projeto_ble_renew/model/pessoa.dart';
import '../components/my_list_tile.dart';
import '../model/dispositivo.dart';
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
  TextEditingController deviceTagController = TextEditingController();
  TextEditingController deviceMacController = TextEditingController();

  List<bool> isSwitched = [true, false];

  _limpa() {
    setState(() {
      userCPFController.text = '';
      userNameController.text = '';
      deviceTagController.text = '';
      deviceMacController.text = '';
    });
  }

  @override
  void dispose() {
    userCPFController.dispose();
    userNameController.dispose();
    deviceTagController.dispose();
    deviceMacController.dispose();
    super.dispose();
  }

  Future<List<Pessoa>> _pesquisaPorNome(String nome) {
    return PessoaDao().findNome(nome);
  }

  Future<List<Pessoa>> _pesquisaPorCPF(String cpf) {
    return PessoaDao().findCPF(cpf);
  }

  Future<List<Dispositivo>> _pesquisaPorTAG() {
    return DispositivoDao().findTAG('${deviceTagController.text}%');
  }

  Future<List<Dispositivo>> _pesquisaPorMAC(String mac) {
    return DispositivoDao().findMAC(mac);
  }

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: ToggleButtons(
                    constraints: BoxConstraints(
                        minHeight: 45,
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
                        if (deviceMacController.text != '') {
                          print('ver mac');
                        } else if (deviceTagController.text != '') {
                          print('ver tag');
                          setState(() {
                          });
                        } else {
                          print('dispositivo inválido');
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
              space,
              Container(
                color: Colors.blue,
                  height: deviceData.height * 0.40,
                  width: deviceData.width * 0.88,
                  child: FutureBuilder<List<Dispositivo>>(
                      future: _pesquisaPorTAG(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final dispositivos = snapshot.data!;
                        return ListView.builder(
                          itemCount: dispositivos.length,
                          itemBuilder: ((context, index) {
                            final dispositivo = dispositivos[index];
                            return MyListTile(
                              onTap: () {},
                              icon: (dispositivo.status!)
                                  ? Icons.bluetooth
                                  : Icons.bluetooth_disabled,
                              text:
                                  'TAG: ${dispositivo.tag} - Tipo: ${dispositivo.tipo}'
                                  '\nMAC: ${dispositivo.mac} \nStatus: ${dispositivo.status}',
                            );
                          }),
                        );
                      })),
            ]),
      ),
    );
  }
}
