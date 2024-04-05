import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/model/funcionario.dart';
import 'package:projeto_ble_renew/model/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/pessoa.dart';
import '../util/banco.dart';
import '../util/constants.dart';

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

  @override
  void initState() {
    _carregaDrop();
    super.initState();
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
      print('from map ${listFuncionario.last.nome}');
    }
    setState(() {});
  }

  //Sign Up User
  Future<String?> signUp() async {
    User? user;
    try {
      final AuthResponse res = await supabase.auth.signUp(
        password: senhaController.text.trim(),
        email: emailController.text.trim(),
      );
      user = res.user;

      if (!mounted) return 'erro';

      //Navigator.pop(context);
    } on AuthException catch (e) {
      debugPrint(e.message);
    }
    return user!.id;
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
                                (op) => DropdownMenuItem(
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
                      String? uid = await signUp();
                      try {
                        UsuarioDao().save(
                          Usuario(
                            funcionario.nome,
                            emailController.text,
                            funcionario.id!,
                            uid,
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
                  child: const Text('Salvar!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
