import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/util/app_cores.dart';
import 'package:projeto_ble_renew/util/constants.dart';

import '../model/usuario.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var cargo = '';
  final TextStyle _texto = const TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.black54,
      fontSize: 16,
      height: 1.3);
  final TextStyle _resposta = const TextStyle(
      fontWeight: FontWeight.bold, color: verdeBotao, fontSize: 18);

  @override
  initState() {
    super.initState();
    _atualizaCargo();
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
                                  radius: 75,
                                  backgroundColor: Colors.grey[200],
                                  child: CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.grey[300],
                                    // backgroundImage:
                                    // imageFile != null ? FileImage(imageFile!) : null,
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[200],
                                    child: IconButton(
                                      onPressed: () {},
                                      //onPressed: _showOpcoesBottomSheet,
                                      icon: Icon(
                                        Icons.edit,
                                        //PhosphorIcons.pencilSimple(),
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
                                      style: _texto,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                LoggedUser.usuarioLogado?.nome,
                                            style: _resposta),
                                      ])),
                            ]),
                      ),
                      RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              text: '\nEmail: ',
                              style: _texto,
                              children: <TextSpan>[
                                TextSpan(
                                    text: LoggedUser.usuarioLogado?.email,
                                    style: _resposta),
                                TextSpan(text: '\n\nStatus: ', style: _texto),
                                TextSpan(
                                    text: (LoggedUser.currentUserID == null)
                                        ? LoggedUser.userLogado?.aud.toString()
                                        : LoggedUser.currentUserID?.user?.aud
                                            .toString(),
                                    style: _resposta),
                                TextSpan(text: '\n\nID: ', style: _texto),
                                TextSpan(
                                    text: (LoggedUser.currentUserID == null)
                                        ? LoggedUser.userLogado?.id.toString()
                                        : LoggedUser.currentUserID?.user?.id
                                            .toString(),
                                    style: _resposta),
                                TextSpan(
                                    text: '\n\nÚltimo acesso: ', style: _texto),
                                TextSpan(
                                    text: (LoggedUser.currentUserID == null)
                                        ? LoggedUser.userLogado?.lastSignInAt
                                            .toString()
                                            .substring(0, 10)
                                        : LoggedUser
                                            .currentUserID?.user?.lastSignInAt
                                            .toString()
                                            .substring(0, 10),
                                    style: _resposta),
                                TextSpan(text: '\n\nCargo: ', style: _texto),
                                TextSpan(text: cargo, style: _resposta),
                              ])),
                    ]),
              ),
            ),
    );
  }
}
