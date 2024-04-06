import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/pages/home_page.dart';
import 'package:projeto_ble_renew/pages/pesquisa.dart';
import '../components/my_list_tile.dart';
import '../model/device_person.dart';
import '../model/dispositivo.dart';
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
  late List<DispUser> listVinculos = []; //Alterar

  List<Pessoa> _listPessoa = [];
  List<Dispositivo> _listDispositivo = [];

  final dispositivoController = TextEditingController();
  final usuarioController = TextEditingController();

  @override
  void initState() {
    _carregaDados();
    _verifica();
    super.initState();
  }

  void _verifica() {
    if (dispositivoController.text == '' || dispositivoController == null) {
      dispositivoController.text = (dispositivoSelecionadoX == null)
          ? ''
          : dispositivoSelecionadoX.toString();
    }
    if (usuarioController.text == '' || usuarioController == null) {
      usuarioController.text =
          (pessoaSelecionadaX == null) ? '' : pessoaSelecionadaX.toString();
    }
  }

  void _carregaDados() async {
    List vinculosTemp = [];
    List pessoasTemp = [];
    List dispositivosTemp = [];
    List dataDU = await supabase.from('vw_dispositivos_usuarios').select();
    List dataPs = await supabase.from('pessoa_fisica').select();
    List dataDp = await supabase.from('dispositivo').select();
    setState(() {
      vinculosTemp.addAll(dataDU);
      pessoasTemp.addAll(dataPs);
      dispositivosTemp.addAll(dataDp);
    });
    for (var i in vinculosTemp) {
      listVinculos.add(DispUser.fromMap(i));
    }
    _listPessoa = await PessoaDao().findAll();
    _listDispositivo = await DispositivoDao().findAll();
  }

  @override
  void dispose() {
    dispositivoController.dispose();
    usuarioController.dispose();
    super.dispose();
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Pesquisa(
                                                      param: 'dispositivo')));
                                      setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
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
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Pesquisa(
                                                    param: 'pessoa_fisica'))),
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
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
                                        //A L T E R A R
                                        _cadastrar(
                                            dispositivoID:
                                                dispositivoSelecionadoX!.id!,
                                            pessoaID: pessoaSelecionadaX!.id!);
                                        setState(() {
                                          dispositivoController.text = '';
                                          usuarioController.text = '';
                                        });
                                      }
                                    },
                                    child: const Text('Vincular')),
                                ElevatedButton(
                                    onPressed: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage())),
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
      //Limpa tudo e retorna
      pessoaSelecionadaX = null;
      dispositivoSelecionadoX = null;
      setState(() {});
    } on Error catch (e) {
      debugPrint(e as String?);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }
}
