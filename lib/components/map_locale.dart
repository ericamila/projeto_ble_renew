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
    super.initState();
    _carregaDados();
    WidgetsBinding.instance.addPostFrameCallback(_getImageSize);
  }

  void _getImageSize(Duration timeStamp) {
    final RenderBox? renderBox =
        _imageKey.currentContext!.findRenderObject() as RenderBox?;
    setState(() {
      _imageSize = renderBox!.size;
    });
  }

  //Não estou considerando os funcionários
  void _carregaDados() async {
    List vinculosTemp = [];
    List dataDU = await supabase.from('vw_dispositivos_usuarios2').select();
    vinculosTemp.addAll(dataDU);
    setState(() {});
    for (var i in vinculosTemp) {
      listVinculos.add(DispUser.fromMap(i));
      devLoc.add({
        'cor': Colors
            .primaries[(listVinculos.length - 1) % Colors.primaries.length],
        'tag': listVinculos.last.tag,
        'destino': Area.getNomeById(listVinculos.last.area!),
        'h': _heightDestination(listVinculos.last.area!),
        //trocar por localização
        'w': _widthDestination(listVinculos.last.area!),
        //trocar por localização
      });
    }
    //print(devLoc);
  }

  double _gerarCoordenada(double min, double max) {
    return (min + Random().nextDouble() * (max + 1 - min));
  }

  _widthDestination(int destino) {
    bool isMobile = (_imageSize.height < 400);
    double fator = _imageSize.width * (isMobile ? 0.93 : 0.94);
    switch (destino) {
      case 1: //RECEPÇÃO
        //MIN 200 MAX 330
        min = fator * 0.59;
        max = fator;
        return _gerarCoordenada(min, max);
      case 2: //PEDIATRIA
        //MIN 119 MAX 180
        min = fator * 0.35;
        max = fator * 0.55;
        return _gerarCoordenada(min, max);
      case 3: //QUARTO 1
      case 4: //QUARTO 2
      case 5: //QUARTO 3
      case 6: //QUARTO 4
        //MIN 0 MAX 68
        min = fator * 0.02;
        max = fator * 0.21;
        return _gerarCoordenada(min, max);
      case 7: //SALA DE RAIO-X
        //MIN 110 MAX 210
        min = fator * 0.35;
        max = fator * 0.63;
        return _gerarCoordenada(min, max);
      case 8: //ORTOPEDIA
        //MIN 253 MAX 330
        min = fator * 0.76;
        max = fator;
        return _gerarCoordenada(min, max);
      case 14: //CORREDOR
        //MIN 80 MAX 243
        min = fator * 0.25;
        max = fator * 0.73;
        return _gerarCoordenada(min, max);
      case 15: //BANHEIROS
        //MIN 253 MAX 330
        min = fator * 0.76;
        max = fator;
        return _gerarCoordenada(min, max);
      default:
        //MIN 80 MAX 243
        min = fator * 0.25;
        max = fator * 0.73;
        return _gerarCoordenada(min, max);
    }
  }

  _heightDestination(int destino) {
    bool isMobile = (_imageSize.height < 400);
    double add = isMobile ? 55.0 : 70.0;
    double fator = _imageSize.height * (isMobile ? 1.07 : 1.01);
    switch (destino) {
      case 1: //RECEPÇÃO
        //MIN 238 MAX 360
        min = fator * 0.65;
        max = fator;
        return _gerarCoordenada(min, max);
      case 2: //PEDIATRIA
        //MIN 280 MAX 360
        min = fator * 0.75;
        max = fator;
        return _gerarCoordenada(min, max);
      case 3: //QUARTO 1
        //MIN 95 MAX 145
        min = fator - (fator - add);
        max = fator * 0.3;
        return _gerarCoordenada(min, max);
      case 4: //QUARTO 2
        //MIN 165 MAX 221
        min = isMobile ? fator * 0.4 : fator * 0.35;
        max = fator * 0.53;
        return _gerarCoordenada(min, max);
      case 5: //QUARTO 3
        //MIN 240 MAX 293
        min = isMobile ? fator * 0.62 : fator * 0.58;
        max = fator * 0.77;
        return _gerarCoordenada(min, max);
      case 6: //QUARTO 4
        //MIN 312 MAX 360
        min = fator * 0.83;
        max = fator;
        return _gerarCoordenada(min, max);
      case 7: //SALA DE RAIO-X
        //MIN 177 MAX 226
        min = isMobile ? fator * 0.4 : fator * 0.35;
        max = fator * 0.56;
        return _gerarCoordenada(min, max);
      case 8: //ORTOPEDIA
        //MIN 95 MAX 171
        min = fator - (fator - add);
        max = fator * 0.36;
        return _gerarCoordenada(min, max);
      case 14: //CORREDOR
        //MIN 95 MAX 150
        min = fator - (fator - add);
        max = fator * 0.31;
        return _gerarCoordenada(min, max);
      case 15: //BANHEIROS
        //MIN 188 MAX 226
        min = fator * 0.43;
        max = fator * 0.56;
        return _gerarCoordenada(min, max);
      //_gerarCoordenada(min, max);
      default: //subtrai 90
        //MIN 95 MAX 150
        min = fator - (fator - add);
        max = fator * 0.31;
        return _gerarCoordenada(min, max);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50.0),
            constraints: BoxConstraints(maxHeight: 750),
            child: Image.asset(mapa, key: _imageKey),
          ),
          Stack(
            children: List.generate(devLoc.length, (index) {
              return Positioned(
                left: devLoc[index]['w'],
                top: devLoc[index]['h'],
                child: InkWell(
                  onTap: () => print(
                      'pw ${devLoc[index]['w']} ph ${devLoc[index]['h']}'),
                  //trocar
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
            alignment: isDesktop() ? Alignment.center : Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isDesktop()) Spacer(flex: 2),
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
                                  Text('Destino: ${devLoc[index]['destino']}'),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Legenda')),
                if (isDesktop()) Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
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
