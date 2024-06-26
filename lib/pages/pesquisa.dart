import 'package:flutter/material.dart';
import '../components/my_list_tile.dart';
import '../model/dispositivo.dart';
import '../model/externo.dart';
import '../model/pessoa.dart';
import '../util/banco.dart';
import '../util/constants.dart';

class Pesquisa extends StatefulWidget {
  final String param;

  const Pesquisa({required this.param, super.key});

  @override
  State<Pesquisa> createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {
  final List<dynamic> _lista = [];

  @override
  void initState() {
    _carregaDados();
    super.initState();
  }

  void _carregaDados() async {
    List listaTemp = [];

    List data = await supabase.from(widget.param).select();

    setState(() {
      listaTemp.addAll(data);
    });

    if (widget.param == 'pessoa_fisica') {
      listaTemp.clear();
      List data = await supabase.from('vw_pessoas_livres').select();
      setState(() {
        listaTemp.addAll(data);
      });

      for (var item in listaTemp) {
        _lista.add(Pessoa.fromMap(item));
      }
    } else if (widget.param == 'externo') {
      //alterar ???
      for (var item in listaTemp) {
        if (item['tipo_externo'] == 'Paciente') {
          _lista.add(ExternoDao().fromMap(item));
        }
      }
    } else {
      listaTemp.clear();
      List data = await supabase.from('vw_dispositivos_livres').select();
      setState(() {
        listaTemp.addAll(data);
      });

      for (var item in listaTemp) {
        _lista.add(Dispositivo.fromMap(item));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: (widget.param == 'externo')
              ? const Text('Vincular Paciente')
              : const Text('Vincular Dispositivos'),
        ),
        body: _lista.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: const Text(
                          'Selecione:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => MyListTile(
                          text: _lista[index].toString(),
                          tileCor: Colors.blueGrey[100 * (index % 2)],
                          icon: (widget.param == 'dispositivo')
                              ? iconDevice(_lista[index].toString())
                              : Icons.account_circle,
                          onTap: () {
                            seleciona(index);
                          }),
                      childCount: _lista.length,
                    ),
                  ),
                ],
              ));
  }

  seleciona(int index) {
    if (widget.param == 'pessoa_fisica') {
      Navigator.pop(context, _lista[index]);
    } else if (widget.param == 'externo') {
      Navigator.pop(context, _lista[index]);
    } else {
      Navigator.pop(context, _lista[index]);
    }
  }

}
