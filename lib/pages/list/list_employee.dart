import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/funcionario.dart';
import '../../model/cargo.dart';
import '../../util/constants.dart';
import '../forms/employee.dart';

class ListaCadastroFuncionario extends StatefulWidget {
  final String tipoCadastro;

  const ListaCadastroFuncionario({super.key, required this.tipoCadastro});

  @override
  State<ListaCadastroFuncionario> createState() => _ListaCadastroFuncionarioState();
}

class _ListaCadastroFuncionarioState extends State<ListaCadastroFuncionario> {
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
        child: FutureBuilder<List<Funcionario>>(
            future: refresh(),
            builder: (context, snapshot) {
              List<Funcionario>? items = snapshot.data;
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
                          final Funcionario funcionario = items[index];
                          return ListTile(
                              title: Text(funcionario.nome),
                              subtitle:
                                  Text(Cargo.getNomeById(funcionario.cargo)),
                              leading: imageLeading(funcionario.foto),
                              onTap: () {},
                              trailing: PopupMenuButton<bool>(
                                onSelected: (value) async {
                                  if (value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (contextNew) => FormCadastroFuncionario(
                                          funcionarioContext: context,
                                          funcionarioEdit: funcionario,
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
                                              'Tem certeza que deseja deletar ${funcionario.nome}?'),
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
                                      await FuncionarioDao()
                                          .delete(funcionario.id!);
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
                    return noData();
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
              builder: (contextNew) => FormCadastroFuncionario(
                  funcionarioContext: context,
                  tipoCadastro: widget.tipoCadastro),
            ),
          ).then((value) {
            refresh();
            if (value == true) {
              showSnackBar(context, "Registro salvo com sucesso.", true);
             /* ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Registro salvo com sucesso."),
                  duration: Duration(seconds: 3),
                ),
              );*/
            } else {
              showSnackBar(context, "Houve uma falha ao registar.", false);
              /*ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Houve uma falha ao registar."),
                  duration: Duration(seconds: 3),
                ),
              );*/
            }
          });
        },
        label: const Text(
          'ADICIONAR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.person_add),
      ),
    );
  }

  Future<List<Funcionario>> refresh() async {
    setState(() {});
    return FuncionarioDao().findAll();
  }
}
