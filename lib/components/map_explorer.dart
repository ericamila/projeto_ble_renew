import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../util/app_cores.dart';
import '../util/constants.dart';

class MapExplorer extends StatefulWidget {
  const MapExplorer({super.key});

  @override
  State<MapExplorer> createState() => _MapExplorerState();
}

class _MapExplorerState extends State<MapExplorer> {
  double _scale = 0.12;

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
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: PhotoView(
                imageProvider: const AssetImage(mapaExplorer),
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
          ),
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
