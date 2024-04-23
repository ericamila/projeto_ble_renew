// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/funcionario.dart';
import 'package:projeto_ble_renew/model/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/pessoa.dart';
import '../../util/banco.dart';
import '../../util/constants.dart';

class FormUsuario extends StatefulWidget {
  final BuildContext usuarioContext;
  final Usuario? usuarioEdit;

  const FormUsuario(
      {super.key, required this.usuarioContext, this.usuarioEdit});

  @override
  State<FormUsuario> createState() => _FormUsuarioState();
}

class _FormUsuarioState extends State<FormUsuario> {
  final _formKey = GlobalKey<FormState>();
  final dropNomeFuncionarioValue = ValueNotifier('');
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final senhaConfController = TextEditingController();
  late List<dynamic> listFuncionario = [];
  String? senhaLogada;

  @override
  void initState() {
    _carregaDrop();
    super.initState();
  }

  void _showPasswordModal(BuildContext context) async {
    senhaLogada = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PasswordModal();
      },
    );
  }

  bool valueValidator(String? value) {
    if (value != null && value.isEmpty) {
      return true;
    }
    return false;
  }

  bool seEditar() {
    return (widget.usuarioEdit != null);
  }

  _carregaDrop() async {
    List listaTemp = [];
    List data = await supabase.from('funcionario').select();
    setState(() {
      listaTemp.addAll(data);
    });
    for (var i in listaTemp) {
      listFuncionario.add(Pessoa.fromMap(i));
    }
    setState(() {});
  }

  //Sign Up User
  Future<String?> signUp() async {
    User? user;

    // Faz logout do usuário atual
    await supabase.auth.signOut();
    print('logout');
    print('id logado ${LoggedUser.usuarioLogado?.email}');

    try {
      final AuthResponse res = await supabase.auth.signUp(
        password: senhaController.text.trim(),
        email: emailController.text.trim(),
      );

      user = res.user;
      print('user ${res.user?.email!.toString()}');

      if (!mounted) return 'erro';

      //Navigator.pop(context);
    } on AuthException catch (e) {
      print('mensagem ' + e.message);
      debugPrint(e.message);
    } finally {
      try {
        print('tentando logar');
        LoggedUser.currentUserID = await supabase.auth.signInWithPassword(
          password: 'eeeeee',
          email: LoggedUser.usuarioLogado?.email,
        );

        Navigator.pushReplacementNamed(context, '/home');
      } on AuthException catch (e) {
        debugPrint(e.message);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senhas inválida!')),
        );
      } on PostgrestException catch (error) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
/*    if (seEditar()) {
      dropNomeFuncionarioValue.value =
          widget.usuarioEdit!.funcionario.toString();
      emailController.text = widget.usuarioEdit!.email;
      senhaController.text = widget.usuarioEdit!.senha;
      senhaConfController.text = widget.usuarioEdit!.confSenha;
      https://supabase.com/dashboard/project/cavikcnsdlhepwnlucge/api?page=users
     api para atualizar
    }*/
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: paddingPadraoFormulario,
                  child: ValueListenableBuilder(
                    valueListenable: dropNomeFuncionarioValue,
                    builder: (BuildContext context, String value, _) {
                      return DropdownButtonFormField<String>(
                          validator: (value) {
                            return (value == null)
                                ? 'Campo obrigatório!'
                                : null;
                          },
                          isExpanded: true,
                          hint: const Text('Selecione'),
                          decoration: myDecoration('*Funcionário'),
                          value: (value.isEmpty) ? null : value,
                          items: listFuncionario
                              .map(
                                (op) =>
                                DropdownMenuItem(
                                  value: op.id.toString(),
                                  child: Text(op.nome),
                                ),
                          )
                              .toList(),
                          onChanged: (escolha) {
                            dropNomeFuncionarioValue.value =
                                escolha.toString();
                          });
                    },
                  ),
                ),
                Padding(
                  padding: paddingPadraoFormulario,
                  child: TextFormField(
                    validator: (String? value) {
                      if (valueValidator(value)) {
                        return 'Preencha o campo';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    textAlign: TextAlign.center,
                    decoration: myDecoration('Email'),
                  ),
                ),
                Padding(
                  padding: paddingPadraoFormulario,
                  child: TextFormField(
                    obscureText: true,
                    validator: (String? value) {
                      if (valueValidator(value)) {
                        return 'Preencha o campo';
                      }
                      return null;
                    },
                    controller: senhaController,
                    textAlign: TextAlign.center,
                    decoration: myDecoration('Senha'),
                  ),
                ),
                Padding(
                  padding: paddingPadraoFormulario,
                  child: TextFormField(
                    obscureText: true,
                    validator: (String? value) {
                      if (valueValidator(value)) {
                        return 'Preencha o campo';
                      }
                      if (value != senhaController.text) {
                        return 'Senha e Confirmação são diferentes!';
                      }
                      return null;
                    },
                    controller: senhaConfController,
                    textAlign: TextAlign.center,
                    decoration: myDecoration('Confirmar Senha'),
                  ),
                ),
                FilledButton(
                  onPressed: () async {
                    setState(() {});
                    if (_formKey.currentState!.validate()) {
                      Funcionario funcionario = await FuncionarioDao()
                          .findID(dropNomeFuncionarioValue.value);
                      await _showPasswordModal;
                      String? uid = await signUp();
                      print('nnoo botao' + uid.toString());
                      try {
                        UsuarioDao().save(
                          Usuario(
                              nome: funcionario.nome,
                              email: emailController.text,
                              funcionario: funcionario.id!,
                              uid: uid,
                              foto: 'https://cavikcnsdlhepwnlucge.supabase.co/storage/v1/object/public/profile/nophoto.png' //usuario novo
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Salvando registro!'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        Navigator.pop(context);
                      } on PostgrestException catch (e) {
                        debugPrint(e.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao salvar registro!'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class PasswordModal extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Enter Password',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              String password = _passwordController.text;
              Navigator.pop(
                  context, password); // Fecha o modal e retorna a senha
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}