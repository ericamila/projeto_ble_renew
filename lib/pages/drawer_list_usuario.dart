import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/funcionario.dart';
import 'package:projeto_ble_renew/model/usuario.dart';
import 'package:projeto_ble_renew/pages/form_register.dart';
import 'package:projeto_ble_renew/pages/form_usuario.dart';

import '../model/cargo.dart';
import '../util/constants.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({super.key});

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
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
        child: FutureBuilder<List<Usuario>>(
            future: UsuarioDao().findAll(),
            builder: (context, snapshot) {
              List<Usuario>? items = snapshot.data;
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
                          final Usuario usuario = items[index];
                          return ListTile(
                              title: Text(usuario.nome),
                              subtitle:
                              Text(usuario.email),
                              leading:
                              const Icon(Icons.account_circle, size: 56),
                              onTap: () {},
                              trailing: PopupMenuButton<bool>(
                                onSelected: (value) async {
                                  if (value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (contextNew) => FormUsuario(
                                          usuarioContext: context, usuarioEdit: usuario,
                                        ),
                                      ),
                                    ).then((value) => setState(() {
                                    }));
                                  } else {
                                    bool deletedConfirmed = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Deletar'),
                                          content: Text(
                                              'Tem certeza que deseja deletar ${usuario.nome}?'),
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
                                      await UsuarioDao()
                                          .delete(usuario.id!);
                                      setState(() {});
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<bool>>[
                                  const PopupMenuItem<bool>(
                                      value: true,
                                      child: ListTile(leading:Icon(Icons.edit) , title: Text('Editar'),)
                                  ),
                                  const PopupMenuItem<bool>(
                                      value: false,
                                      child: ListTile(leading:Icon(Icons.delete_forever) , title: Text('Excluir'),)
                                  ),
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
              builder: (contextNew) => FormUsuario(
                usuarioContext: context,
              ),
            ),
          ).then((value) => setState(() {
          }));
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
