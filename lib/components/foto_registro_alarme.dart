import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: depend_on_referenced_packages
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'dart:io';

import '../util/banco.dart';
import '../util/constants.dart';

class FotoAlarme extends StatefulWidget {
  final String id;

  const FotoAlarme({super.key, required this.id});

  @override
  State<FotoAlarme> createState() => _FotoAlarmeState();
}

class _FotoAlarmeState extends State<FotoAlarme> {
  List<XFile>? _mediaFileList;

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(ImageSource source, {
    required BuildContext context,
    bool isMedia = false,
  }) async {
    if (context.mounted) {
      if (isMedia) {
        await _displayPickImageDialog(context,
                (double? maxWidth, double? maxHeight, int? quality) async {
              try {
                final List<XFile> pickedFileList = <XFile>[];
                final XFile? media = await _picker.pickMedia(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  imageQuality: quality,
                );
                if (media != null) {
                  pickedFileList.add(media);
                  setState(() {
                    _mediaFileList = pickedFileList;
                  });
                }
              } catch (e) {
                setState(() {
                  _pickImageError = e;
                });
              }
            });
      } else {
        await _displayPickImageDialog(context,
                (double? maxWidth, double? maxHeight, int? quality) async {
              try {
                final XFile? pickedFile = await _picker.pickImage(
                  source: source,
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  imageQuality: quality,
                );
                setState(() {
                  _setImageFileListFromFile(pickedFile);
                });
              } catch (e) {
                setState(() {
                  _pickImageError = e;
                });
              }
            });
      }
    }
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            final String? mime = lookupMimeType(_mediaFileList![index].path);
            // Salvar e pop
            // Why network for web?
            // See https://pub.dev/packages/image_picker_for_web#limitations-on-the-web-platform
            if (mime != null) {
              _recuperaFoto(_mediaFileList![index]);
            }

            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_mediaFileList![index].path)
                  : (mime == null || mime.startsWith('image/')
                  ? Image.file(
                File(_mediaFileList![index].path),
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return const Center(
                      child: Text(
                          'Este tipo de imagem não é compatível.'));
                },
              )
                  : nada),
            );
          },
          itemCount: _mediaFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Erro de escolha de imagem:$_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Você ainda não escolheu uma imagem.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _mediaFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
          future: retrieveLostData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Text(
                  'Você ainda não escolheu uma imagem.',
                  textAlign: TextAlign.center,
                );
              case ConnectionState.done:
                return _handlePreview();
              case ConnectionState.active:
                if (snapshot.hasError) {
                  return Text(
                    'Erro de escolha de imagem: ${snapshot.error}}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const Text(
                    'Você ainda não escolheu uma imagem.',
                    textAlign: TextAlign.center,
                  );
                }
            }
          },
        )
            : _handlePreview(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Escolha uma imagem da galeria',
              child: const Icon(Icons.photo),
            ),
          ),
          if (_picker.supportsImageSource(ImageSource.camera))
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                heroTag: 'image2',
                tooltip: 'Tire uma foto',
                child: const Icon(Icons.camera_alt),
              ),
            ),
        ],
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(BuildContext context,
      OnPickImageCallback onPick) async {
    onPick(null, null, null);
  }

  void _recuperaFoto(XFile? image) async {
    final imageExtension = image?.path
        .split('.')
        .last
        .toLowerCase();
    final imageBytes = await image?.readAsBytes();
    final imagePath = '/${widget.id}/profile';
    await supabase.storage.from('registro_fotos').uploadBinary(
      imagePath,
      imageBytes!,
      fileOptions: FileOptions(
        upsert: true,
        contentType: 'image/$imageExtension',
      ),
    );

    String imageUrl = await supabase.storage.from('registro_fotos').getPublicUrl(imagePath);

    Navigator.pop(context, imageUrl);
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
