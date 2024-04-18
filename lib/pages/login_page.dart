// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import '../model/usuario.dart';
import '../util/app_cores.dart';
import '../util/banco.dart';
import '../util/constants.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController(text: "erica@email.com");//apagar em produção
  TextEditingController passwordController = TextEditingController(text: "eeeeee");//apagar em produção

  @override
  void initState() {
    super.initState();
  }

  //LOGAR USUÁRIO
  Future<void> signIn() async {
    try {
      LoggedUser.currentUserID = await supabase.auth.signInWithPassword(
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
      );
      if (!mounted) return;

      LoggedUser.usuarioLogado = await UsuarioDao().findUUID(
          LoggedUser.currentUserID!.user!.userMetadata!['sub'].toString());

      Navigator.pushReplacementNamed(context, '/home');

    } on AuthException catch (e) {
      debugPrint(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email e/ou senhas inválidos!')),
      );
    } on PostgrestException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ConnectionNotifier.of(context).value;
    final asset =
        hasConnection ? 'Conectado' : 'Verifique sua conexão com a Internet';
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                asset == 'Conectado'
                    ? nada
                    : ListTile(
                        tileColor: Colors.blueGrey,
                        leading: const Icon(
                          Icons.wifi_off,
                          color: Colors.white70,
                        ),
                        title: Text(
                          asset.toString(),
                          style: const TextStyle(color: claro),
                        )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(
                    'images/codelink_alt.png',
                    height: 96,
                    color: verde,
                  ),
                ),
                Text("Codelink",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.grey[800])),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: myDecorationLogin(texto: "Email", icone: const Icon(Icons.email)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: myDecorationLogin(texto: "Senha", icone: const Icon(Icons.lock)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                  child: FilledButton(
                    onPressed: signIn,
                    child: const Text("Entrar"),
                  ),
                ),
                GestureDetector(
                    onTap: () {}, //alterar
                    child: RichText(
                      text: TextSpan(
                        text: 'Esqueceu a ',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.normal),
                        children: const <TextSpan>[
                          TextSpan(
                              text: 'senha',
                              style: TextStyle(
                                  color: verdeBotao,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(text: '?'),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
