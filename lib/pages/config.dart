import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_ble_renew/model/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../util/banco.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  final ImagePicker picker = ImagePicker();
  XFile? _imagem;
  String _idUsuarioLogado = '';
  String? _urlImagemRecuperada = null;

  Future _recuperarImagem() async {
    XFile? imagemSelecionada =
        (await picker.pickImage(source: ImageSource.gallery));

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
    });
  }

  _atualizarUrlImagemFirestore(String url) async {
    await supabase
        .from('usuario')
        .update({'foto': url}).match({'uid': _idUsuarioLogado});
  }

  _recuperarDadosUsuario() async {
    _idUsuarioLogado = LoggedUser.userLogado!.id;

    final snapshot = await supabase
        .from('usuario')
        .select('foto')
        .eq('uid', _idUsuarioLogado);

    Map<String, dynamic> data = snapshot.last;

    if (data["foto"] != null) {
      setState(() {
        _urlImagemRecuperada = data["foto"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (_urlImagemRecuperada == null)
                ? const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()))
                : CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.grey,
                    backgroundImage: (_urlImagemRecuperada != null)
                        ? NetworkImage(_urlImagemRecuperada!)
                        : const NetworkImage(
                            'https://cavikcnsdlhepwnlucge.supabase.co/storage/v1/object/public/profile/nophoto.png')),
            ElevatedButton(
                onPressed: () {
                  _recuperarImagem();
                },
                child: const Text("Galeria")),
          ],
        ),
      ),
    );
  }
}
