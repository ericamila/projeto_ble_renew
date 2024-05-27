import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_ble_renew/util/app_cores.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../util/banco.dart';
import '../util/constants.dart';

class Foto extends StatelessWidget {
  Foto({
    super.key,
    required this.imageUrl,
    required this.onUpload,
    this.uUID,
  });

  final String? imageUrl;
  final void Function(String imageUrl) onUpload;
  final ImagePicker picker = ImagePicker();
  final String? uUID;
  final double size = 250;
  final double maxWidth = 500;
  final double maxHeight = 575;
  final int quality = 80; // inteiro de 0-100

  _recuperaFoto(XFile? image) async {
    final imageExtension = image?.path.split('.').last.toLowerCase();
    final imageBytes = await image?.readAsBytes();
    final imagePath = '/$uUID/profile';
    await supabase.storage.from('bucket_fotos').uploadBinary(
      imagePath,
      imageBytes!,
      fileOptions: FileOptions(
        upsert: true,
        contentType: 'image/$imageExtension',
      ),
    );
    String imageUrl =
    supabase.storage.from('bucket_fotos').getPublicUrl(imagePath);
    imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
      't': DateTime.now().millisecondsSinceEpoch.toString()
    }).toString();
    onUpload(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(imagemPadraoAsset),
              fit: BoxFit.cover,
            ),
            border: Border.all(width: 2.0, color: AppColors.verdeBotao),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: imageUrl != null
                ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
            )
                : Container(
              color: Colors.grey,
              child: Image.asset(imagemPadraoAsset),
            ),
          ),
        ),
        spaceMenor,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxHeight: maxHeight,
                    maxWidth: maxWidth,
                    imageQuality: quality);
                if (image == null) {
                  return;
                }
                _recuperaFoto(image);
              },
              child: const Row(
                children: [
                  Icon(Icons.photo),
                  Text('Galeria'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    maxHeight: maxHeight,
                    maxWidth: maxWidth,
                    imageQuality: quality);
                if (image == null) {
                  return;
                }
                _recuperaFoto(image);
              },
              child: const Row(
                children: [
                  Icon(Icons.camera_alt),
                  Text('Câmera'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}