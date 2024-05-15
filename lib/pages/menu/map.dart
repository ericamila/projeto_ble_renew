import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:projeto_ble_renew/util/constants.dart';

import '../../util/app_cores.dart';

class MenuMapa extends StatefulWidget {
  const MenuMapa({super.key});

  @override
  State<MenuMapa> createState() => _MenuMapaState();
}

class _MenuMapaState extends State<MenuMapa> {
  double _scale = 0.3;

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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: PhotoView(
                  imageProvider:
                      const AssetImage('images/planta_baixa_zero.jpg'),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2.0,
                  backgroundDecoration: const BoxDecoration(
                    color: claro,
                  ),
                  loadingBuilder: (context, event) {
                    if (event == null) return const SizedBox();
                    final progress =
                        event.cumulativeBytesLoaded / event.expectedTotalBytes!;
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.zoom_in),
                  onPressed: _zoomIn,
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out),
                  onPressed: _zoomOut,
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
}
