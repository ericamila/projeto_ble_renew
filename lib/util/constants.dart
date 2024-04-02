import 'package:flutter/material.dart';

import '../model/dispositivo.dart';
import '../model/pessoa.dart';
import '../model/usuario.dart';

const space = Padding(padding: EdgeInsets.all(8));
const spaceMenor = Padding(padding: EdgeInsets.all(4));
const nada = Padding(padding: EdgeInsets.all(0));
final borderRadiusPadrao =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));
const paddingPadraoFormulario = EdgeInsets.all(12.0);
var currentUserID;
late Usuario usuarioLogado;
Dispositivo? dispositivoSelecionadoX;
Pessoa? pessoaSelecionadaX;
// A P A G A R
const sizeFontToggleButtons = 15.0;

const carregando = Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircularProgressIndicator(),
      Text('Carregando'),
    ],
  ),
);

InputDecoration myDecoration(String texto) {
  return InputDecoration(
      border: const OutlineInputBorder(),
      label: Text(texto),
      contentPadding: const EdgeInsets.all(15),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabled: true,
      filled: true,
      fillColor: Colors.white70);
}