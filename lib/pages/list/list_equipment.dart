import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/equipamento.dart';
import '../../util/constants.dart';
import '../forms/equipment.dart';


class ListaCadastroEquipamento extends StatefulWidget {
  final String tipoCadastro;

  const ListaCadastroEquipamento({super.key, required this.tipoCadastro});

  @override
  State<ListaCadastroEquipamento> createState() => _ListaCadastroEquipamentoState();
}

class _ListaCadastroEquipamentoState extends State<ListaCadastroEquipamento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.tipoCadastro}s'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 70),
        child: FutureBuilder<List<Equipamento>>(
            future: EquipamentoDao().findAll(),
            builder: (context, snapshot) {
              List<Equipamento>? items = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return carregando;
                case ConnectionState.done:
                  if (snapshot.hasData && items != null) {
                    if (items.isNotEmpty) {
                      return ListView.separated(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Equipamento equipamento = items[index];
                          return ListTile(
                              title: Text(equipamento.descricao),
                              subtitle:
                                  Text(equipamento.codigo),
                              leading:
                                  const Icon(Icons.devices_other_outlined, size: 56),
                              onTap: () {},
                              trailing: PopupMenuButton<bool>(
                                onSelected: (value) async {
                                  if (value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (contextNew) => FormCadastroEquipamento(
                                          equipamentoContext: context,
                                          equipamentoEdit: equipamento,
                                          tipoCadastro: widget.tipoCadastro,
                                        ),
                                      ),
                                    ).then((value) => setState(() {}));
                                  } else {
                                    bool deletedConfirmed = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Deletar'),
                                          content: Text(
                                              'Tem certeza que deseja deletar ${equipamento.descricao}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                              child: const Text('Deletar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (deletedConfirmed) {
                                      await EquipamentoDao()
                                          .delete(equipamento.id!);
                                      setState(() {});
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<bool>>[
                                  const PopupMenuItem<bool>(
                                      value: true,
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('Editar'),
                                      )),
                                  const PopupMenuItem<bool>(
                                      value: false,
                                      child: ListTile(
                                        leading: Icon(Icons.delete_forever),
                                        title: Text('Excluir'),
                                      )),
                                ],
                              ));
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      );
                    }
                    return const Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 96,
                        ),
                        Text(
                          'Não há nenhum dado.',
                          style: TextStyle(fontSize: 32),
                        ),
                      ],
                    ));
                  }
                  return const Text('Erro ao carregar dados');
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contextNew) => FormCadastroEquipamento(
                  equipamentoContext: context,
                  tipoCadastro: widget.tipoCadastro),
            ),
          ).then((value) => setState(() {}));
        },
        label: const Text(
          'ADICIONAR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.person_add),
      ),
    );
  }
}
