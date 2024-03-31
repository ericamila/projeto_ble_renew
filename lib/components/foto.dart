import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../util/banco.dart';

class Foto extends StatelessWidget {
  const Foto({
    super.key,
    required this.imageUrl,
    required this.onUpload,
    required this.uUID,
  });

  final String? imageUrl;
  final void Function(String imageUrl) onUpload;
  final String? uUID;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: imageUrl != null
              ? Image.network(
                  height: 200,
                  width: 200,
                  imageUrl!,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Colors.grey,
                  child: Image.asset('images/nophoto.png', height: 200),
                ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image =
                await picker.pickImage(source: ImageSource.gallery);
            if (image == null) {
              return;
            }
            final imageExtension = image.path.split('.').last.toLowerCase();
            final imageBytes = await image.readAsBytes();
            final userId = uUID;
            final imagePath = '/$userId/profile';
            await supabase.storage.from('bucket_fotos').uploadBinary(
                  imagePath,
                  imageBytes,
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
          },
          child: const Text('Upload'),
        ),
      ],
    );
  }
}
