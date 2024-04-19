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

const TextStyle textoPerfil = TextStyle(
    fontWeight: FontWeight.normal,
    color: Colors.black54,
    fontSize: 16,
    height: 1.3);
const TextStyle respostaPerfil = TextStyle(
    fontWeight: FontWeight.bold, color: verdeBotao, fontSize: 18);

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

InputDecoration myDecorationLogin({required String texto, Icon? icone}) {
  return InputDecoration(
      hintText: texto,
      prefixIcon: icone,
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
      hintStyle: TextStyle(fontSize: 16.0, color: Colors.blueGrey.shade300),
      contentPadding: const EdgeInsets.all(12),
      filled: true,
      fillColor: Colors.white70);
}

void showSnackBar(BuildContext context, String message, bool sucess) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: (sucess) ? Colors.teal : Colors.orangeAccent,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
