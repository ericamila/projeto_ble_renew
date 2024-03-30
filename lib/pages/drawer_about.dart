import 'package:flutter/material.dart';

import '../util/constants.dart';

class Sobre extends StatelessWidget {
  const Sobre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EQUIPE CODELINK',
        ),
      ),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: const Color(0xFF292935),
          floating: true,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            child: Center(
              child: Image.asset(
                'images/codelink_alt.png',
                height: 65,
              ),
            ),
          ),
          expandedHeight: 100,
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              space,
              const Text(
                'Daniel Sousa de Araujo '
                '\nErica Camila Silva Cunha '
                '\nIraneide dos Santos de Oliveira '
                '\nJhonny Costa de Souza '
                '\nWarlly Carlos Martins Machado'
                '\nOrientador: Raimundo Silva'
                '\n\nProjeto Residência em TIC:\nGestão de fluxo de pessoas em hospital',
                style: TextStyle(color: Colors.blueGrey, fontSize: 19),
                textAlign: TextAlign.center,
              ),
              spaceMenor,
              Column(
                children: [
                  Image.asset('images/softex.png'),
                  Image.asset('images/pmbv.png', width: 280),
                  Image.asset('images/gfbrasil.png'),
                  spaceMenor,
                  Image.asset('images/brisa.png'),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
