import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/dispositivo.dart';
import '../model/pessoa.dart';
import 'app_cores.dart';

final ImagePicker picker = ImagePicker();
const String imagemPadraoUrl = 'images/nophoto.png';
final Image imagemPadrao = Image.asset(imagemPadraoUrl, height: 250);

const space = Padding(padding: EdgeInsets.all(8));
const spaceMenor = Padding(padding: EdgeInsets.all(4));
const nada = Padding(padding: EdgeInsets.all(0));
final borderRadiusPadrao =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));
const paddingPadraoFormulario = EdgeInsets.all(12.0);
ButtonStyle estiloSearchButton = ElevatedButton.styleFrom(
    minimumSize: const Size(140, 43),
    backgroundColor: verde,
    foregroundColor: claro);

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

ClipRRect imageLeading(String? foto) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: foto != null
          ? Image.network(height: 58, width: 58, foto, fit: BoxFit.cover)
          : Container(color: Colors.grey, child: Image.asset(imagemPadraoUrl)));
}

InputDecoration myDecoration(String texto, {Icon? icone}) {
  return InputDecoration(
      border: const OutlineInputBorder(),
      label: Text(texto),
      contentPadding: const EdgeInsets.all(15),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabled: true,
      filled: true,
      fillColor: Colors.white70,
      prefixIcon: icone);
}
