import 'dart:math';

import 'package:flutter/material.dart';
import '../model/area.dart';
import '../model/device_person.dart';
import '../util/banco.dart';
import '../util/constants.dart';

class MapLocale extends StatefulWidget {
  const MapLocale({super.key});

  @override
  State<MapLocale> createState() => _MapLocaleState();
}

class _MapLocaleState extends State<MapLocale> {
  late List<DispUser> listVinculos = [];
  List<Map<String, dynamic>> devLoc = [];
  final GlobalKey _imageKey = GlobalKey();
  late Size _imageSize;
  double min = 0;
  double max = 0;

  @override
  void initState() {
    _carregaDados();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getImageSize);
  }

  void _getImageSize(Duration timeStamp) {
    final RenderBox? renderBox = _imageKey.currentContext!.findRenderObject() as RenderBox?;
    setState(() {
      _imageSize = renderBox!.size;
    });
    print(_imageSize);
  }

  //Não estou considerando os funcionários
  void _carregaDados() async {
    List vinculosTemp = [];
    List dataDU = await supabase.from('vw_dispositivos_usuarios2').select();
    vinculosTemp.addAll(dataDU);
    setState(() {

    });
    for (var i in vinculosTemp) {
      listVinculos.add(DispUser.fromMap(i));
      devLoc.add({
        'cor': Colors
            .primaries[(listVinculos.length - 1) % Colors.primaries.length],
        'tag': listVinculos.last.tag,
        'destino': Area.getNomeById(listVinculos.last.area!),
        'h': _heightDestination(listVinculos.last.area!),//trocar por localização
        'w': _widthDestination(listVinculos.last.area!),//trocar por localização
      });
    }
    //print(devLoc);
  }

  double _gerarCoordenada(double min, double max) {
    //print('v a l o r ${min + Random().nextDouble() * (max + 1 - min)}');
    return (min + Random().nextDouble() * (max + 1 - min));
  }

  _widthDestination(int destino) {
    switch (destino) {
      case 1: //RECEPÇÃO
        //MIN 200 MAX 330
        min = 200.0;
        max = 330.0;
        return _gerarCoordenada(min, max);
      case 2: //PEDIATRIA
        //MIN 119 MAX 180
        min = 119.0;
        max = 180.0;
        return _gerarCoordenada(min, max);
      case 3: //QUARTO 1
      case 4: //QUARTO 2
      case 5: //QUARTO 3
      case 6: //QUARTO 4
        //MIN 0 MAX 68
        min = 0.0;
        max = 68.0;
        return _gerarCoordenada(min, max);
      case 7: //SALA DE RAIO-X
        //MIN 110 MAX 210
        min = 110.0;
        max = 210.0;
        return _gerarCoordenada(min, max);
      case 8: //ORTOPEDIA
        //MIN 253 MAX 330
        min = 253.0;
        max = 330.0;
        return _gerarCoordenada(min, max);
      case 14: //CORREDOR
        //MIN 80 MAX 243
        min = 80.0;
        max = 243.0;
        return _gerarCoordenada(min, max);
      case 15: //BANHEIROS
        //MIN 253 MAX 330
        min = 253.0;
        max = 330.0;
        return _gerarCoordenada(min, max);
      default:
        //MIN 80 MAX 243
        min = 80.0;
        max = 243.0;
        return _gerarCoordenada(min, max);
    }
  }

  _heightDestination(int destino) {
    switch (destino) {
      case 1: //RECEPÇÃO
        //MIN 238 MAX 360
        min = 148.0 + 50;
        max = 270.0 + 50;
        return _gerarCoordenada(min, max);
      case 2: //PEDIATRIA
        //MIN 280 MAX 360
        min = 190.0 + 50;
        max = 270.0 + 50;
        return _gerarCoordenada(min, max);
      case 3: //QUARTO 1
        //MIN 95 MAX 145
        min = 05.0 + 50;
        max = 055.0 + 50;
        return _gerarCoordenada(min, max);
      case 4: //QUARTO 2
        //MIN 165 MAX 221
        min = 075.0 + 50;
        max = 131.0 + 50;
        return _gerarCoordenada(min, max);
      case 5: //QUARTO 3
        //MIN 240 MAX 293
        min = 150.0 + 50;
        max = 203.0 + 50;
        return _gerarCoordenada(min, max);
      case 6: //QUARTO 4
        //MIN 312 MAX 360
        min = 222.0 + 50;
        max = 270.0 + 50;
        return _gerarCoordenada(min, max);
      case 7: //SALA DE RAIO-X
        //MIN 177 MAX 226
        min = 087.0 + 50;
        max = 136.0 + 50;
        return _gerarCoordenada(min, max);
      case 8: //ORTOPEDIA
        //MIN 95 MAX 171
        min = 05.0 + 50;
        max = 081.0 + 50;
        return _gerarCoordenada(min, max);
      case 14: //CORREDOR
        //MIN 95 MAX 150
        min = 05.0 + 50;
        max = 060.0 + 50;
        return _gerarCoordenada(min, max);
      case 15: //BANHEIROS
        //MIN 188 MAX 226
        min = 098.0 + 50;
        max = 136.0 + 50;
        return _gerarCoordenada(min, max);
      default://subtrai 90
        //MIN 95 MAX 150
        min = 5.0 + 50;
        max = 60.0 + 50;
        return _gerarCoordenada(min, max);
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * .38;
    final w = MediaQuery.of(context).size.width * .92;
    return Scaffold(
      body: Stack(
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Image.asset(mapa, key: _imageKey),
          ),
          /*posicao(h: 303.0, w:340, color: Colors.red, locale: 'locale'),
          posicao(h: 70, w:340, color: Colors.red, locale: 'locale'),*/
          Stack(
            children: List.generate(devLoc.length, (index) {
              return Positioned(
                left: devLoc[index]['w'],
                top: devLoc[index]['h'],
                child: InkWell(
                  onTap: () =>  print(MediaQuery.of(context).size.height),
                  child: Icon(Icons.person_pin_circle,
                      color: Colors.primaries[index % Colors.primaries.length],
                      size: 24),
                ),
              );
            }),
          ),
          //BOTÃO
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            alignment: Alignment.bottomCenter,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                              height: 200,
                              child: ListView.builder(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                                itemCount: devLoc.length,
                                itemBuilder: (context, index) => Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.person_pin_circle,
                                          color: devLoc[index]['cor'] as Color,
                                          size: 24,
                                        ),
                                        Text(devLoc[index]['tag']),
                                      ],
                                    ),
                                    Text(
                                        'Destino: ${devLoc[index]['destino']}'),
                                  ],
                                ),
                              ));
                        });
                  },
                  child: const Text('Legenda')),
            ]),
          ),
        ],
      ),
    );
  }

  /* @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * .38;
    final w = MediaQuery.of(context).size.width * .92;
    List<Offset> positions = [Offset(50, 50), Offset(100, 100), Offset(150, 150)];
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: h * .04),
              child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                              height: 200,
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                itemCount: listVinculos.length,
                                itemBuilder: (context, index) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.person_pin_circle,
                                      color:
                                          _getColor(listVinculos[index].tipo),
                                      size: 24,
                                    ),
                                    Text(listVinculos[index].tag),
                                    const Text('Destino: '),
                                  ],
                                ),
                              ));
                        });
                  },
                  child: const Text('Legenda')),
            ),
            Center(
              child: Stack(
                children:
                  */ /*Center(
                    key: _imageKey,
                    child: Image.asset(mapa),
                  ),*/ /*
                  List.generate(positions.length, (index) {
                    return Positioned(
                      left: positions[index].dx,
                      top: positions[index].dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            positions[index] = Offset(
                              positions[index].dx + details.delta.dx,
                              positions[index].dy + details.delta.dy,
                            );
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.primaries[index % Colors.primaries.length],
                          child: Center(
                            child: Text('Item $index'),
                          ),
                        ),
                      ),
                    );
                  }),


                  */ /*posicao(
                      h: h * .0, w: 0, color: Colors.blue, locale: 'Quarto 1'),
                  posicao(
                      h: h * .0,
                      w: w * .2,
                      color: Colors.blue,
                      locale: 'Quarto 1'),
                  posicao(
                      h: h * .2,
                      w: w * .2,
                      color: Colors.blue,
                      locale: 'Quarto 1'),
                  posicao(
                      h: h * .2, w: 0, color: Colors.blue, locale: 'Quarto 1'),
                  posicao(
                      h: h * .28,
                      w: 0,
                      color: Colors.green,
                      locale: 'Quarto 2'),
                  posicao(
                      h: h * .28,
                      w: w * .2,
                      color: Colors.green,
                      locale: 'Quarto 2'),
                  posicao(
                      h: h * .48,
                      w: w * .2,
                      color: Colors.green,
                      locale: 'Quarto 2'),
                  posicao(
                      h: h * .48,
                      w: 0,
                      color: Colors.green,
                      locale: 'Quarto 2'),
                  posicao(
                      h: h * .56, w: 0, color: Colors.red, locale: 'Quarto 3'),
                  posicao(
                      h: h * .56,
                      w: w * .2,
                      color: Colors.red,
                      locale: 'Quarto 3'),
                  posicao(
                      h: h * .76,
                      w: w * .2,
                      color: Colors.red,
                      locale: 'Quarto 3'),
                  posicao(
                      h: h * .76, w: 0, color: Colors.red, locale: 'Quarto 3'),
                  posicao(
                      h: h * .82, w: 0, color: Colors.grey, locale: 'Quarto 4'),
                  posicao(
                      h: h * .82,
                      w: w * .2,
                      color: Colors.grey,
                      locale: 'Quarto 4'),
                  posicao(
                      h: h, w: w * .2, color: Colors.grey, locale: 'Quarto 4'),
                  posicao(h: h, w: 0, color: Colors.grey, locale: 'Quarto 4'),
                  posicao(
                      h: h * .6,
                      w: w * .6,
                      color: Colors.pink,
                      locale: 'Recepção'),
                  posicao(
                      h: h * .6, w: w, color: Colors.pink, locale: 'Recepção'),
                  posicao(
                      h: h, w: w * .6, color: Colors.pink, locale: 'Recepção'),
                  posicao(h: h, w: w, color: Colors.pink, locale: 'Recepção'),
                  posicao(
                      h: h * .72,
                      w: w * .35,
                      color: Colors.deepOrangeAccent,
                      locale: 'Laboratório 1'),
                  posicao(
                      h: h * .72,
                      w: w * .55,
                      color: Colors.deepOrangeAccent,
                      locale: 'Laboratório 1'),
                  posicao(
                      h: h,
                      w: w * .35,
                      color: Colors.deepOrangeAccent,
                      locale: 'Laboratório 1'),
                  posicao(
                      h: h,
                      w: w * .55,
                      color: Colors.deepOrangeAccent,
                      locale: 'Laboratório 1'),
                  posicao(
                      h: h * .51,
                      w: w * .35,
                      color: Colors.amber,
                      locale: 'Pediatria'),
                  posicao(
                      h: h * .51,
                      w: w * .62,
                      color: Colors.amber,
                      locale: 'Pediatria'),
                  posicao(
                      h: h * .31,
                      w: w * .35,
                      color: Colors.amber,
                      locale: 'Pediatria'),
                  posicao(
                      h: h * .31,
                      w: w * .62,
                      color: Colors.amber,
                      locale: 'Pediatria'),
                  posicao(
                      h: 0,
                      w: w * .76,
                      color: Colors.cyan,
                      locale: 'Ortopedia'),
                  posicao(h: 0, w: w, color: Colors.cyan, locale: 'Ortopedia'),
                  posicao(
                      h: h * .3,
                      w: w * .76,
                      color: Colors.cyan,
                      locale: 'Ortopedia'),
                  posicao(
                      h: h * .3, w: w, color: Colors.cyan, locale: 'Ortopedia'),
                  posicao(
                      h: h * .36,
                      w: w * .76,
                      color: Colors.purple,
                      locale: 'Banheiros'),
                  posicao(
                      h: h * .36,
                      w: w,
                      color: Colors.purple,
                      locale: 'Banheiros'),
                  posicao(
                      h: h * .52,
                      w: w * .76,
                      color: Colors.purple,
                      locale: 'Banheiros'),
                  posicao(
                      h: h * .52,
                      w: w,
                      color: Colors.purple,
                      locale: 'Banheiros'),*/ /*

              ),
            ),
          ],
        ),
      ),
    );
  }*/

  List<Widget> _getPositioned() {
    List<Widget> list = [];
    for (var i in listVinculos) {
      list.add(posicao(h: 300, w: 300, color: Colors.black, locale: 'locale'));
    }
    return list;
  }
}

Widget posicao({
  required double h,
  required double w,
  required Color color,
  required String locale,
}) {
  return Positioned(
    top: h,
    left: w,
    child: Icon(Icons.person_pin_circle, color: color, size: 24),
  );
}
