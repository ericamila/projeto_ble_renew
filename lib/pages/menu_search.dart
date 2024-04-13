import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/pessoa.dart';
import 'package:projeto_ble_renew/util/app_cores.dart';
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
  TextEditingController macController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  List<bool> isSwitched = [true, false];

  @override
  void initState() {
    carrega();
    super.initState();
  }

  @override
  void dispose() {
    cpfController.dispose();
    nameController.dispose();
    tagController.dispose();
    macController.dispose();
    super.dispose();
  }

  List<Dispositivo> dispositivos = [];
  List<Pessoa> pessoas = [];

  carrega() async {
    dispositivos = await DispositivoDao().findAll();
    pessoas = await PessoaDao().findAll();
  }

  String pesquisa = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisa', style: TextStyle(color: escuro)),
        backgroundColor: claro,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(215.0),
          child: Column(
            children: [
              ToggleButtons(
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
              space,
              Row(
                children: <Widget>[
                  space,
                  (isSwitched[0])
                      ? Expanded(
                          child: TextField(
                            controller: cpfController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                pesquisa = value;
                                nameController.text = '';
                              });
                            },
                            decoration: myDecoration('CPF',
                                icone: const Icon(Icons.search)),
                            inputFormatters: [cpfFormatter],
                          ),
                        )
                      : Expanded(
                          child: TextField(
                            controller: tagController,
                            onChanged: (value) {
                              setState(() {
                                pesquisa = value;
                                macController.text = '';
                              });
                            },
                            decoration: myDecoration('TAG',
                                icone: const Icon(Icons.search)),
                              textCapitalization: TextCapitalization.characters
                          ),
                        ),
                  IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          pesquisa = '';
                          tagController.text = '';
                          cpfController.text = '';
                        });
                      }),
                ],
              ),
              spaceMenor,
              const Center(child: Text('OU')),
              spaceMenor,
              Row(children: <Widget>[
                space,
                (isSwitched[0])
                    ? Expanded(
                        child: TextField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              pesquisa = value;
                              cpfController.text = '';
                            });
                          },
                          decoration: myDecoration('Nome',
                              icone: const Icon(Icons.search)),
                        ),
                      )
                    : Expanded(
                        child: TextField(
                            controller: macController,
                            onChanged: (value) {
                              setState(() {
                                pesquisa = value;
                                tagController.text = '';
                              });
                            },
                            decoration: myDecoration('MAC',
                                icone: const Icon(Icons.search)),
                            inputFormatters: [macFormatter],
                            textCapitalization: TextCapitalization.characters),
                      ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      pesquisa = '';
                      macController.text = '';
                      nameController.text = '';
                    });
                  },
                ),
              ]),
              space,
            ],
          ),
        ),
      ),
      body: Hero(
        tag: 'ListTile-Pesquisa',
        child: Material(
          child: (isSwitched[0])
              ? ListView.builder(
                  itemCount: pessoas.length,
                  itemBuilder: (context, index) {
                    if (pesquisa.isEmpty ||
                        pessoas[index].cpf.contains(pesquisa) ||
                        pessoas[index].nome.contains(pesquisa)) {
                      return MyListTile(
                          text: pessoas[index].nome,
                          icon: Icons.account_circle,
                          subText: pessoas[index].cpf,
                          tileCor: _getCor(index),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<Widget>(
                                  builder: (BuildContext context) {
                                return Scaffold(
                                  appBar: AppBar(
                                      title: const Text('Pessoa Selecionada')),
                                  body: Center(
                                    child: Hero(
                                      tag: 'ListTile-Pesquisa',
                                      child: Material(
                                        child: MyListTile(
                                            text: 'ListTile with Hero',
                                            onTap: () {
                                              Navigator.pop(context);
                                            }),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          });
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                )
              : ListView.builder(
                  itemCount: dispositivos.length,
                  itemBuilder: (context, index) {
                    if (pesquisa.isEmpty ||
                        dispositivos[index].tag!.contains(pesquisa) ||
                        dispositivos[index].mac!.contains(pesquisa)) {
                      return MyListTile(
                          text: dispositivos[index].tag!,
                          icon: Icons.bluetooth,
                          subText: dispositivos[index].mac!,
                          tileCor: _getCor(index),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<Widget>(
                                  builder: (BuildContext context) {
                                return Scaffold(
                                  appBar: AppBar(
                                      title: const Text(
                                          'Dispositivo Selecionado')),
                                  body: Center(
                                    child: Hero(
                                      tag: 'ListTile-Pesquisa',
                                      child: Material(
                                        child: MyListTile(
                                            text: 'ListTile with Hero',
                                            onTap: () {
                                              Navigator.pop(context);
                                            }),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          });
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
        ),
      ),
    );
  }

  Color? _getCor(int index) {
    switch (index % 2) {
      case 0:
        return Colors.blueGrey[100];
      case 1:
        return claro;
      default:
        return Colors.blueGrey[100 * (index + 1)];
    }
  }
}
