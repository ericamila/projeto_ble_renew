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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //LOGAR USUÁRIO
  Future<void> signIn() async {
    try {
      currentUserID = await supabase.auth.signInWithPassword(
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
      );
      if (!mounted) return;

      await pegaUsuario();

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } on AuthException catch (e) {
      debugPrint(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email e/ou senhas inválidos!')),
      );
    }
  }

  pegaUsuario() async {
    Usuario usuarioTemp = await UsuarioDao()
        .findUUID(currentUserID.user.userMetadata['sub'].toString());
    usuarioLogado = usuarioTemp;
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
                      border: Border.all(color: Colors.blue.shade50),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.white70,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          hintStyle: TextStyle(
                              fontSize: 16.0, color: Colors.blueGrey.shade300),
                          contentPadding: const EdgeInsets.all(12),
                          filled: true,
                          fillColor: Colors.white70),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue.shade50),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Senha',
                          prefixIcon: const Icon(Icons.lock),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.white30,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.white30),
                          ),
                          hintStyle: TextStyle(
                              fontSize: 16.0, color: Colors.blueGrey.shade300),
                          contentPadding: const EdgeInsets.all(12),
                          filled: true,
                          fillColor: Colors.white70),
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
