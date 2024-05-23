import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:projeto_ble_renew/util/constants.dart';
import 'dart:math' as math;
import '../../model/device_person.dart';
import '../../model/dispositivo.dart';
import '../../model/pessoa.dart';
import '../../util/app_cores.dart';
import '../../util/banco.dart';

class MenuMapa extends StatefulWidget {
  const MenuMapa({super.key});

  @override
  State<MenuMapa> createState() => _MenuMapaState();
}

class _MenuMapaState extends State<MenuMapa> {
  List<bool> isSwitched = [true, false];
  double _scale = 0.12;
  late List<DispUser> listVinculos = [];
  Dispositivo? dispositivo;
  List<Map<String, dynamic>> devLoc = [];

  @override
  void initState() {
    _carregaDados();
    super.initState();
  }

  void _carregaDados() async {
    List vinculosTemp = [];
    List dataDU = await supabase.from('vw_dispositivos_usuarios').select();
    setState(() {
      vinculosTemp.addAll(dataDU);
    });
    for (var i in vinculosTemp) {
      listVinculos.add(DispUser.fromMap(i));
      devLoc.add({
        'cor': _getColor(listVinculos.last.tipo),
        'tag': listVinculos.last.tag,
        'destino': listVinculos.last.tag
      });
    }
    print(devLoc);
  }

  void _zoomIn() {
    setState(() {
      _scale *= 1.25;
    });
  }

  void _zoomOut() {
    setState(() {
      _scale /= 1.25;
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleButtons(
                constraints: BoxConstraints(minHeight: 45, minWidth: w * 0.37),
                isSelected: isSwitched,
                onPressed: (index) {
                  setState(() {
                    isSwitched[0] = !isSwitched[0];
                    isSwitched[1] = !isSwitched[1];
                  });
                },
                children: const [
                  Text(' Mapa de Localização ', style: styleToggleButtons),
                  Text('Mapa Exploratório', style: styleToggleButtons),
                ]),
            if (isSwitched[0]) //LOCALIZAÇÃO
              Padding(
                padding: EdgeInsets.only(top: h * .04, bottom: h * .04),
                child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
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
            (isSwitched[1]) //EXPLORATÓRIO
                ? Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: PhotoView(
                        imageProvider: const AssetImage(mapa),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2.0,
                        backgroundDecoration: const BoxDecoration(
                          color: claro,
                        ),
                        loadingBuilder: (context, event) {
                          if (event == null) return const SizedBox();
                          final progress = event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!;
                          return Center(
                            child: CircularProgressIndicator(
                              value: progress,
                            ),
                          );
                        },
                        scaleStateController: PhotoViewScaleStateController(),
                        scaleStateCycle: customScaleState,
                        initialScale: _scale,
                      ),
                    ),
                  )
                : (isDesktop())
                    ? Center(
                        //LOCALIZAÇÃO DESKTOP
                        child: Container(
                          constraints: BoxConstraints.expand(height: h * .65),
                          decoration: const BoxDecoration(
                              image: DecorationImage(image: AssetImage(mapa))),
                          child: Stack(
                            children: [
                              Positioned(
                                left: w * .4,
                                top: h * .37,
                                child: const Icon(Icons.person_pin_circle,
                                    color: Colors.red, size: 24),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(//LOCALIZAÇÃO MOBILE
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(mapa),
                            ),
                            //ListenableBuilder(listenable: listenable, builder: builder),
                            Positioned(
                              left: 0,
                              top: h * .38,
                              child: const Icon(Icons.person_pin_circle,
                                  color: Colors.amber, size: 24),
                            ),
                            const Positioned(
                              left: 0,
                              top: 0,
                              child: Icon(Icons.person_pin_circle,
                                  color: Colors.amber, size: 24),
                            ),
                            Positioned(
                              left: w * .92,
                              top: 0,
                              child: const Icon(Icons.person_pin_circle,
                                  color: Colors.amber, size: 24),
                            ),
                            Positioned(
                              left: w * .92,
                              top: h* .38,
                              child: const Icon(Icons.person_pin_circle,
                                  color: Colors.amber, size: 24),
                            ),
                            Positioned(
                              left: w * .93,
                              top: h * .37,
                              child: const Icon(Icons.person_pin_circle,
                                  color: Colors.blueAccent, size: 24),
                            ),
                            Positioned(
                              left: w * .93,
                              top: 0,
                              child: const Icon(Icons.person_pin_circle,
                                  color: Colors.green, size: 24),
                            ),
                            Positioned(
                              left: w,
                              top: 5,
                              child: const Icon(Icons.person_pin_circle,
                                  color: Colors.amber, size: 24),
                            ),
                          ],
                        ),
                      ),
            if (isSwitched[1]) //EXPLORATÓRIO
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.zoom_out),
                    onPressed: _zoomOut,
                  ),
                  IconButton(
                    icon: const Icon(Icons.zoom_in),
                    onPressed: _zoomIn,
                  ),
                ],
              ),
            space,
          ],
        ),
      ),
    );
  }

  PhotoViewScaleState customScaleState(PhotoViewScaleState actual) {
    switch (actual) {
      case PhotoViewScaleState.initial:
        return PhotoViewScaleState.covering;
      case PhotoViewScaleState.covering:
        return PhotoViewScaleState.originalSize;
      case PhotoViewScaleState.originalSize:
        return PhotoViewScaleState.initial;
      default:
        return PhotoViewScaleState.initial;
    }
  }

  Color _getColor(String param) {
    switch (param) {
      case 'Pulseira':
        return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0);
      case 'Crachá':
        return Color((math.Random().nextDouble() * 0xff72d89c).toInt())
            .withOpacity(1.0);
      case 'Etiqueta':
        return Colors.amber;
      default:
        return Colors.blueGrey;
    }
  }
}
