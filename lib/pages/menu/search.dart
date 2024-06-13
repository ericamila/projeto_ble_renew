// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/area.dart';
import 'package:projeto_ble_renew/model/funcionario.dart';
import 'package:projeto_ble_renew/model/pessoa.dart';
import 'package:projeto_ble_renew/util/app_cores.dart';
import 'package:projeto_ble_renew/util/banco.dart';

import '../../components/my_list_tile.dart';
import '../../model/cargo.dart';
import '../../model/dispositivo.dart';
import '../../model/externo.dart';
import '../../util/constants.dart';
import '../../util/formatters.dart';

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
  var selecionado;
  Externo? pacienteTemp;

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
    pacienteTemp = null;
  }

  List<Dispositivo> listDevices = [];
  List<Pessoa> listPersons = [];

  carrega() async {
    listDevices = await DispositivoDao().findAll();
    listPersons = await PessoaDao().findAll();
    setState(() {});
  }

  bool isUser() {
    return isSwitched[0];
  }

  String pesquisa = '';
  Map<String, dynamic> dataUser = {};
  String? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Pesquisa', style: TextStyle(color: AppColors.escuro)),
        backgroundColor: AppColors.claro,
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
                  (isUser())
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
                              textCapitalization:
                                  TextCapitalization.characters),
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
                (isUser())
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
      body: (listDevices.isEmpty && listPersons.isEmpty)
          ? carregando
          : Hero(
              tag: 'ListTile-Pesquisa',
              child: Material(
                child: (isUser())
                    ? ListView.builder(
                        itemCount: listPersons.length,
                        itemBuilder: (context, index) {
                          if (pesquisa.isEmpty ||
                              listPersons[index].cpf.contains(pesquisa) ||
                              listPersons[index].nome.contains(pesquisa)) {
                            return MyListTile(
                                text: listPersons[index].nome,
                                icon: Icons.account_circle,
                                subText: listPersons[index].cpf,
                                tileCor: getCor(index),
                                onTap: () async {
                                  await _carregaDadosPessoa(
                                      tipo: listPersons[index]
                                          .tipoExterno
                                          .toString(),
                                      idPessoa:
                                          listPersons[index].id.toString());
                                  _showUser(context);
                                });
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      )
                    : ListView.builder(
                        itemCount: listDevices.length,
                        itemBuilder: (context, index) {
                          if (pesquisa.isEmpty ||
                              listDevices[index].tag!.contains(pesquisa) ||
                              listDevices[index].mac!.contains(pesquisa)) {
                            return MyListTile(
                                text: listDevices[index].tag!,
                                icon: iconDevice(listDevices[index].tipo!),
                                subText: listDevices[index].mac!,
                                tileCor: getCor(index),
                                onTap: () {
                                  _carregaData(listDevices[index].mac!);
                                  setState(() {});
                                  _showDevice(context, index);
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

  void _showDevice(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Dispositivo Selecionado')),
          body: Center(
            child: Hero(
              tag: 'ListTile-Pesquisa',
              child: Material(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Card(
                    color: Colors.grey[100],
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      width: 310,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Image.asset(
                                  'images/${pegaImagem(listDevices[index].tipo.toString())}',
                                  height: 150,
                                  color: AppColors.verdeBotao)),
                          space,
                          (listDevices[index].nome != '')
                              ? Column(
                                  children: [
                                    textoFormatado('Nome',
                                        listDevices[index].nome.toString(),
                                        alinhamento: TextAlign.start),
                                    space,
                                  ],
                                )
                              : nada,
                          textoFormatado('TAG', listDevices[index].tag!,
                              alinhamento: TextAlign.start),
                          space,
                          textoFormatado('Tipo', listDevices[index].tipo!,
                              alinhamento: TextAlign.start),
                          space,
                          textoFormatado('MAC', listDevices[index].mac!,
                              alinhamento: TextAlign.start),
                          space,
                          textoFormatado(
                            'Status',
                            (listDevices[index].status!)
                                ? 'Conectado'
                                : 'Desconectado',
                          ),
                          space,
                          if (data != null)
                            textoFormatado('Início', data.toString(),
                                alinhamento: TextAlign.start),
                          space,
                          Center(
                            child: OutlinedButton(
                                onPressed: (listDevices[index].status!)
                                    ? () async {
                                        await _getUsuario(
                                            listDevices[index].mac!);
                                        _showUser(context);
                                      }
                                    : null,
                                style: TextButton.styleFrom(),
                                child: const Text('Exibir Usuário')),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showUser(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchDetails(
                selecionado: selecionado, paciente: pacienteTemp)));
  }

  Future<void> _carregaDadosPessoa(
      {required String tipo, required String idPessoa}) async {
    if (tipo == "Funcionário") {
      selecionado = await FuncionarioDao().findID(idPessoa);
    } else {
      selecionado = await ExternoDao().findID(idPessoa);
      if (selecionado.paciente != null) {
        pacienteTemp = await ExternoDao().findID(selecionado.paciente);
      }
    }
  }

  _getUsuario(String macDevice) async {
    dataUser = await supabase
        .from('vw_dispositivos_usuarios')
        .select()
        .eq('mac', macDevice)
        .single();

    _carregaDadosPessoa(
        tipo: dataUser['tipo_externo'], idPessoa: dataUser['pessoa_id']);
  }

  void _carregaData(String mac) async {
    var dataUser = await supabase
        .from('vw_dispositivos_usuarios')
        .select('data_time_inicio')
        .eq('mac', mac)
        .single();

    setState(() {
      data = dataUser['data_time_inicio'];
    });
  }
}

// ignore: must_be_immutable
class SearchDetails extends StatefulWidget {
  Externo? paciente;
  final selecionado;

  SearchDetails({
    super.key,
    required this.selecionado,
    this.paciente,
  });

  @override
  State<SearchDetails> createState() => _SearchDetailsState();
}

class _SearchDetailsState extends State<SearchDetails> {
  @override
  void dispose() {
    widget.paciente = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pessoa Selecionada')),
      body: Center(
        child: Hero(
          tag: 'ListTile-Pesquisa',
          child: Material(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Card(
                color: Colors.grey[100],
                child: Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: imagemClipRRect(
                              widget.selecionado.foto ?? imagemPadraoNetwork),
                        ),
                        //ALTERAR
                        space,
                        textoFormatado('Nome', widget.selecionado!.nome),
                        space,
                        textoFormatado('CPF', widget.selecionado!.cpf),
                        space,
                        (widget.selecionado.runtimeType.toString() == 'Externo')
                            ? ifExternal()
                            : ifEmployee(),
                        space,
                        Center(
                          child: OutlinedButton(
                              onPressed: () async {
                                Dispositivo? device = await _getDevice(
                                    idUser: widget.selecionado.id);
                                if (device != null) {
                                  _showDevice(context, device);
                                } else {
                                  showSnackBarDefault(context,
                                      message:
                                          'Usuário não possui dispositivo vinculado!');
                                }
                              },
                              style: TextButton.styleFrom(),
                              child: const Text('Exibir Dispositivo')),
                        )
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ifEmployee() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textoFormatado('Cargo', Cargo.getNomeById(widget.selecionado!.cargo)),
      ],
    );
  }

  ifExternal() {
    Externo externo = widget.selecionado;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textoFormatado('Tipo', externo.tipoExterno!),
        space,
        textoFormatado('Área', Area.getNomeById(externo.area!)),
        space,
        (externo.paciente != null)
            ? textoFormatado('Paciente', widget.paciente!.nome)
            : nada,
      ],
    );
  }

  Future<Dispositivo?> _getDevice({required String idUser}) async {
    List<Map<String, dynamic>> dataDevice = await supabase
        .from('vw_dispositivos_usuarios')
        .select()
        .eq('pessoa_id', idUser);

    if (dataDevice.isNotEmpty) {
      List<Dispositivo> dispositivos =
          await DispositivoDao().findMAC(dataDevice.first['mac']);
      if (dispositivos.isNotEmpty) {
        return dispositivos.first;
      }
      return null;
    }
    return null;
  }

  void _showDevice(BuildContext context, Dispositivo device) {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Dispositivo Selecionado')),
          body: Center(
            child: Hero(
              tag: 'ListTile-Pesquisa',
              child: Material(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Card(
                    color: Colors.grey[100],
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      width: 310,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Image.asset(
                                  'images/${pegaImagem(device.tipo.toString())}',
                                  height: 150,
                                  color: AppColors.verdeBotao)),
                          space,
                          (device.nome != '')
                              ? Column(
                                  children: [
                                    textoFormatado(
                                        'Nome', device.nome.toString(),
                                        alinhamento: TextAlign.start),
                                    space,
                                  ],
                                )
                              : nada,
                          textoFormatado('TAG', device.tag!,
                              alinhamento: TextAlign.start),
                          space,
                          textoFormatado('Tipo', device.tipo!,
                              alinhamento: TextAlign.start),
                          space,
                          textoFormatado('MAC', device.mac!,
                              alinhamento: TextAlign.start),
                          space,
                          textoFormatado(
                            'Status',
                            (device.status!) ? 'Conectado' : 'Desconectado',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
