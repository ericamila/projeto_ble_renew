import 'package:flutter/material.dart';

import '../util/constants.dart';

class MenuPesquisa extends StatefulWidget {
  const MenuPesquisa({super.key});

  @override
  State<MenuPesquisa> createState() => _MenuPesquisaState();
}

class _MenuPesquisaState extends State<MenuPesquisa> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Usuário:"),
            const TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'ID',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nome',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Dispositivo:"),
            ),
            const TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'ID',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nome',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'MacAddress',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            space,
            Center(
              child: FilledButton(
                onPressed: () {},
                child: const Text("Cadastrar"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Resultado:"),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: ListTile(
                title: Text('Resultado 1'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
