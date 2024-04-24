// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/dispositivo.dart';
import 'package:projeto_ble_renew/pages/pesquisa.dart';
import '../components/my_list_tile.dart';
import '../model/device_person.dart';
import '../model/pessoa.dart';
import '../util/banco.dart';
import '../util/constants.dart';

class VincularDispositivos extends StatefulWidget {
  const VincularDispositivos({super.key});

  @override
  State<VincularDispositivos> createState() => _VincularDispositivosState();
}

class _VincularDispositivosState extends State<VincularDispositivos> {
  final _formKey = GlobalKey<FormState>();
  late List<DispUser> listVinculos = [];
  final dispositivoController = TextEditingController();
  final usuarioController = TextEditingController();
  Dispositivo? dispositivoTemp;
  Pessoa? pessoaTemp;

  @override
  void initState() {
    _carregaDados();
    super.initState();
  }

  void _carregaDados() async {
    List vinculosTemp = [];
    List dataDU = await supabase.from('vw_dispositivos_usuarios').select();
    setState(() {
      vinculosTemp.addAll(dataDU);
    });
    for (var i in vinculosTemp) {
      listVinculos.add(DispUser.fromMap(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vincular Dispositivos'),
        ),
        body: listVinculos.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            space,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    key: const ValueKey('dispositivo'),
                                    controller: dispositivoController,
                                    validator: (value) {
                                      return (value == null || value.isEmpty)
                                          ? 'Preencha este campo'
                                          : null;
                                    },
                                    decoration: myDecoration('Dispositivo'),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _pesquisaDispositivo(context);
                                    },
                                    style: buttonPesquisa,
                                    child: const Icon(Icons.search))
                              ],
                            ),
                            space,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    key: const ValueKey('usuario'),
                                    controller: usuarioController,
                                    validator: (value) {
                                      return (value == null || value.isEmpty)
                                          ? 'Preencha este campo'
                                          : null;
                                    },
                                    decoration: myDecoration('Usuário'),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () => _pesquisaPessoa(context),
                                    style: buttonPesquisa,
                                    child: const Icon(Icons.search)),
                              ],
                            ),
                            space,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Processando dados')),
                                        );
                                        _cadastrar(
                                            dispositivoID: dispositivoTemp!.id!,
                                            pessoaID: pessoaTemp!.id!);
                                        setState(() {
                                          dispositivoController.text = '';
                                          usuarioController.text = '';
                                        });
                                      }
                                    },
                                    child: const Text('Vincular')),
                                ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pushReplacementNamed(
                                            context, '/home'),
                                    child: const Text('   Voltar   ')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: space),
                  const SliverToBoxAdapter(
                    child: Text(
                      'Dispositivos ativos:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF081E27),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => MyListTile(
                          text: listVinculos[index].nome,
                          subText:
                              '${listVinculos[index].mac} - ${listVinculos[index].tipo}',
                          tileCor: Colors.blueGrey[100 * (index % 2)],
                          onTap: () {}),
                      childCount: listVinculos.length,
                    ),
                  ),
                ],
              ));
  }

  Future<dynamic> _pesquisaPessoa(BuildContext context) {
    return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Pesquisa(param: 'pessoa_fisica')))
        .then((pessoa) async {
      await _carregaPessoa(pessoa);
      setState(() {});
    });
  }

  void _pesquisaDispositivo(BuildContext context) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Pesquisa(param: 'dispositivo')))
        .then((dispositivo) async {
      await _carregaDispositivo(dispositivo);
      setState(() {});
    });
  }

  //CADASTRAR
  Future<void> _cadastrar(
      {required String dispositivoID, required String pessoaID}) async {
    try {
      await supabase.from('dispositivo_pessoa').insert({
        'dispositivo_id': dispositivoID,
        'pessoa_id': pessoaID,
      }).select();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
      _carregaDados();
      setState(() {});
    } on Error catch (e) {
      debugPrint(e as String?);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  Future<void> _carregaDispositivo(Dispositivo dispositivo) async {
    if (dispositivo.id != null) {
      dispositivoTemp = await DispositivoDao().findID(dispositivo.id!);
    }
    setState(() {
      dispositivoController.text = dispositivo.toString();
    });
  }

  Future<void> _carregaPessoa(Pessoa pessoa) async {
    if (pessoa.id != null) {
      pessoaTemp = await PessoaDao().findID(pessoa.id!);
    }
    setState(() {
      usuarioController.text = pessoa.toString();
    });
  }
}
