import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_ble_renew/util/app_cores.dart';
import 'package:projeto_ble_renew/util/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/usuario.dart';
import '../util/banco.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final imagePicker = ImagePicker();
  File? imageFile;
  var cargo = '';
  String? _imageUrl;

  @override
  initState() {
    super.initState();
    _imageUrl = LoggedUser.usuarioLogado?.foto;
    _atualizaCargo();
  }

  _atualizaCargo() async {
    cargo = (await LoggedUser.pegaCargo())!;
    setState(() {});
  }

  pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        print(pickedFile.path);
      });

      try {
        final bytes = await imageFile?.readAsBytes();
        final fileExt = imageFile?.path.split('.').last;
        final fileName = '${LoggedUser.usuarioLogado!.id}/${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;
        await supabase.storage.from('avatars').uploadBinary(
          filePath,
          bytes!,
        );
        final imageUrlResponse = await supabase.storage
            .from('avatars')
            .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);

        print(imageUrlResponse);
      } on StorageException catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Unexpected error occurred'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }

      print('FOI');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: (cargo == '')
          ? carregando
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        color: verde,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(children: [
                                CircleAvatar(
                                  radius: 78,
                                  backgroundColor: Colors.grey[200],
                                  child: CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: imageFile != null
                                        ? FileImage(imageFile!)
                                        : null,
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    child: IconButton(
                                      onPressed: _showOpcoesBottomSheet,
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: 'Usuário\n',
                                      style: textoPerfil,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                LoggedUser.usuarioLogado?.nome,
                                            style: respostaPerfil),
                                      ])),
                            ]),
                      ),
                      RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: '\nEmail: ',
                              style: textoPerfil,
                              children: <TextSpan>[
                                TextSpan(
                                    text: LoggedUser.usuarioLogado?.email,
                                    style: respostaPerfil),
                                const TextSpan(
                                    text: '\n\nStatus: ', style: textoPerfil),
                                TextSpan(
                                    text: LoggedUser.userLogado?.aud.toString(),
                                    style: respostaPerfil),
                                const TextSpan(
                                    text: '\n\nID: ', style: textoPerfil),
                                TextSpan(
                                    text: LoggedUser.userLogado?.id.toString(),
                                    style: respostaPerfil),
                                const TextSpan(
                                    text: '\n\nÚltimo acesso: ',
                                    style: textoPerfil),
                                TextSpan(
                                    text: LoggedUser.userLogado?.lastSignInAt
                                        .toString()
                                        .substring(0, 10),
                                    style: respostaPerfil),
                                const TextSpan(
                                    text: '\n\nCargo: ', style: textoPerfil),
                                TextSpan(text: cargo, style: respostaPerfil),
                              ])),
                    ]),
              ),
            ),
    );
  }

  void _showOpcoesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: const Text('Galeria'),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: const Text('Remover'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    imageFile = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
