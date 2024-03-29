import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/my_list_tile.dart';
import 'package:projeto_ble_renew/model/funcionario.dart';
import 'package:projeto_ble_renew/pages/form_register.dart';

import '../model/cargo.dart';
import '../util/constants.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Funcionários'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 70),
        child: FutureBuilder<List<Funcionario>>(
            future: FuncionarioDao().findAll(),
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
                      return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Funcionario funcionario = items[index];
                            return MyListTile(
                              text: funcionario.nome,
                              subText: Cargo.getNomeById(funcionario.cargo),
                              icon: Icons.account_circle,
                              onTap: () {},
                            );
                            Divider;
                          });
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
              builder: (contextNew) => FormCadastro(
                funcionarioContext: context,
              ),
            ),
          ).then((value) => setState(() {
                print('Recarregando a tela inicial');
              }));
        },
        label: const Text('ADICIONAR', style: TextStyle(fontWeight: FontWeight.bold),),
        icon: const Icon(Icons.person_add),
      ),
    );
  }
}
