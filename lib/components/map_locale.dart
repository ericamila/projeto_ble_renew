import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../model/area.dart';
import '../model/device_person.dart';
import '../model/dispositivo.dart';
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

  @override
  void initState() {
    _carregaDados();
    super.initState();
  }

  //Não estou considerando os funcionários
  void _carregaDados() async {
    List vinculosTemp = [];
    List dataDU = await supabase.from('vw_dispositivos_usuarios2').select();
    setState(() {
      vinculosTemp.addAll(dataDU);
    });
    for (var i in vinculosTemp) {
      listVinculos.add(DispUser.fromMap(i));
      devLoc.add({
        'cor': Colors.primaries[listVinculos.length % Colors.primaries.length],
        'tag': listVinculos.last.tag,
        'destino': Area.getNomeById(listVinculos.last.area!),
        'h': _heightDestination(listVinculos.last.area!),
        'w': _widthDestination(listVinculos.last.area!),
      });
    }
    print(devLoc);
  }

  _widthDestination(int destino) {
    switch (destino) {
      case 1:
        return 110.0;
      case 2:
        return 200.0;
      case 3:
        return 30.0;
      case 4:
        return 40.0;
      case 5:
        return 0.0;
      case 6:
        return 70.5;
      case 7:
        return 124.6;
      case 8:
        return 40.7;
      case 9:
        return 100.2;
      default:
        return 95.6;
    }
  }

  _heightDestination(int destino) {
//verificar com switch e gerar valor ran^dimico
// gerar valor aleatorio com o limite de largura amx e min
    switch (destino) {
      case 1:
        return 110.0;
      case 2:
        return 120.0;
      case 3:
        return 230.0;
      case 4:
        return 140.0;
      case 5:
        return 0.0;
      case 6:
        return 170.5;
      case 7:
        return 124.6;
      case 8:
        return 340.7;
      case 9:
        return 100.2;
      default:
        return 95.6;
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
            padding: EdgeInsets.only(top: h * .04),
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
                                    Icon(
                                      Icons.person_pin_circle,
                                      color: devLoc[index]['cor'] as Color,
                                      size: 24,
                                    ),
                                    Text(devLoc[index]['tag']),
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
          Center(
            key: _imageKey,
            child: Image.asset(mapa),
          ),
          Stack(
            children: List.generate(devLoc.length, (index) {
              return Positioned(
                left: devLoc[index]['w'],
                top: devLoc[index]['h'],
                child: Icon(Icons.person_pin_circle,
                    color: Colors.primaries[index % Colors.primaries.length],
                    size: 24),
              );
            }),
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
