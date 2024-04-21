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
  String cargo = '';
  XFile? _imagem;
  String? _urlImagemRecuperada;
  late String nome;
  late String email;
  late String status;
  late String id;
  late String acess;

  @override
  initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  void dispose() {
    _urlImagemRecuperada = null;
    super.dispose();
  }

  Future _recuperarImagem(ImageSource source) async {
    XFile? imagemSelecionada = await imagePicker.pickImage(source: source);

    setState(() {
      _imagem = imagemSelecionada;
      if (_imagem != null) {
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() async {
    final imageExtension = _imagem?.path.split('.').last.toLowerCase();
    final imageBytes = await _imagem?.readAsBytes();
    final imagePath = '/${LoggedUser.userLogado?.id}/profile';
    setState(() {});
    await supabase.storage.from('profile').uploadBinary(
          imagePath,
          imageBytes!,
          fileOptions: FileOptions(
            upsert: true,
            contentType: 'image/$imageExtension',
          ),
        );

    // Recuperar URL da imagem
    String imageUrl = supabase.storage.from('profile').getPublicUrl(imagePath);
    imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
      't': DateTime.now().millisecondsSinceEpoch.toString()
    }).toString();
    _recuperarUrlImagem(imageUrl);
  }

  Future _recuperarUrlImagem(String url) async {
    _atualizarUrlImagemFirestore(url);

    setState(() {
      _urlImagemRecuperada = url;
      LoggedUser.usuarioLogado?.foto = url;
    });
  }

  _atualizarUrlImagemFirestore(String url) async {
    try {
      await supabase.from('usuario').update({'foto': url}).match({'uid': id});
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
            content: const Text('Erro inesperado'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  _recuperarDadosUsuario() async {
    id = LoggedUser.userLogado!.id;
    nome = LoggedUser.usuarioLogado!.nome;
    email = LoggedUser.userLogado!.email!;
    status = LoggedUser.userLogado!.aud.toString();
    acess = LoggedUser.userLogado!.lastSignInAt.toString().substring(0, 10);
    _atualizaCargo();

    if (LoggedUser.usuarioLogado?.foto != null) {
      setState(() {
        _urlImagemRecuperada = LoggedUser.usuarioLogado?.foto;
      });
    }
  }

  _atualizaCargo() async {
    cargo = (await LoggedUser.pegaCargo())!;
    setState(() {});
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
                                    backgroundImage: (_urlImagemRecuperada !=
                                            null)
                                        ? NetworkImage(_urlImagemRecuperada!)
                                        : const NetworkImage(
                                            'https://cavikcnsdlhepwnlucge.supabase.co/storage/v1/object/public/profile/nophoto.png'),
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
                                            text: nome, style: respostaPerfil),
                                      ])),
                            ]),
                      ),
                      RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: '\nEmail: ',
                              style: textoPerfil,
                              children: <TextSpan>[
                                TextSpan(text: email, style: respostaPerfil),
                                const TextSpan(
                                    text: '\n\nStatus: ', style: textoPerfil),
                                TextSpan(text: status, style: respostaPerfil),
                                const TextSpan(
                                    text: '\n\nID: ', style: textoPerfil),
                                TextSpan(text: id, style: respostaPerfil),
                                const TextSpan(
                                    text: '\n\nÚltimo acesso: ',
                                    style: textoPerfil),
                                TextSpan(text: acess, style: respostaPerfil),
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
                  _recuperarImagem(ImageSource.gallery);
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
                  _recuperarImagem(ImageSource.camera);
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
                    _urlImagemRecuperada = null;
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
