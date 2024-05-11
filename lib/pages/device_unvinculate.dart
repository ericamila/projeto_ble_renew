// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/dispositivo.dart';
import 'package:projeto_ble_renew/util/confirmation_dialog.dart';
import '../components/my_list_tile.dart';
import '../model/device_person.dart';
import '../model/pessoa.dart';
import '../util/banco.dart';
import '../util/constants.dart';

class DesvincularDispositivos extends StatefulWidget {
  const DesvincularDispositivos({super.key});

  @override
  State<DesvincularDispositivos> createState() =>
      _DesvincularDispositivosState();
}

class _DesvincularDispositivosState extends State<DesvincularDispositivos> {
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
        title: const Text('Desvincular Dispositivos'),
      ),
      body: listVinculos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
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
                const SliverToBoxAdapter(child: Divider()),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => MyListTile(
                        trailing: Icons.arrow_forward_ios_outlined,
                        text: listVinculos[index].nome,
                        subText:
                            '${listVinculos[index].mac} - ${listVinculos[index].tipo}',
                        tileCor: Colors.blueGrey[100 * (index % 2)],
                        onTap: () {
                          showConfirmationDialog(context,
                                  content:
                                      'Você realmente deseja desvincular ${listVinculos[index].nome} de ${listVinculos[index].tag.toString()}?')
                              .then((value) {
                            if (value != null && value) {
                              _desvincular(listVinculos[index].id)
                                  .then((value) => setState(() {}));
                            }
                          });
                        }),
                    childCount: listVinculos.length,
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _desvincular(int id) async {
    try {
      await supabase
          .from('dispositivo_pessoa')
          .update({
            'vinculado': 'FALSE',
            'data_time_fim': DateTime.now().toString(),
          })
          .eq('id', id)
          .then((value) =>
              showSnackBarDefault(context, message:  "Registro atualizado com sucesso.", sucess: true))
          .then((value) => setState(() {
                listVinculos.clear();
                _carregaDados();
              }));
    } catch (error) {
      showSnackBarDefault(context, message: "Houve uma falha ao registar.", sucess: false);
    }
  }
}
