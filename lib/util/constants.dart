import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'app_cores.dart';

const String imagemPadraoAsset = 'images/nophoto.png';
const String mapa = 'images/planta_baixa_zero.jpg';
const String mapaExplorer = 'images/planta_baixa.jpg';
const String imagemPadraoNetwork =
    'https://cavikcnsdlhepwnlucge.supabase.co/storage/v1/object/public/profile/nophoto.png';
final Image imagemPadrao = Image.asset(imagemPadraoAsset, height: 250);

final ImagePicker picker = ImagePicker();
const space = Padding(padding: EdgeInsets.all(8));
const spaceMenor = Padding(padding: EdgeInsets.all(4));
const nada = Padding(padding: EdgeInsets.all(0));
final borderRadiusPadrao =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));
const paddingPadraoFormulario = EdgeInsets.all(12.0);

ButtonStyle estiloSearchButton = ElevatedButton.styleFrom(
    minimumSize: const Size(140, 43),
    backgroundColor: AppColors.verde,
    foregroundColor: AppColors.claro);

ButtonStyle buttonPesquisa = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ));

const TextStyle textoPerfil = TextStyle(
    fontWeight: FontWeight.normal,
    color: Colors.black54,
    fontSize: 16,
    height: 1.3);

const TextStyle respostaPerfil = TextStyle(
    fontWeight: FontWeight.bold, color: AppColors.verdeBotao, fontSize: 18);

const sizeFontToggleButtons = 15.0;
const TextStyle styleToggleButtons = TextStyle(fontSize: 15);

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
          : Container(
              color: Colors.grey, child: Image.asset(imagemPadraoAsset)));
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

void showSnackBarDefault(BuildContext context,
    {String message = "Registro salvo com sucesso.", bool sucess = true}) {
  final snackBar = SnackBar(
    content: Text(message), //Descomentar abaixo para personaliar
    // backgroundColor: (sucess) ? Colors.teal : Colors.orangeAccent,
    // behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

RichText textoFormatado(String question, String answer,
    {TextAlign? alinhamento}) {
  return RichText(
      textAlign: (alinhamento != null) ? alinhamento : TextAlign.center,
      text: TextSpan(
          text: '$question: ',
          style: textoPerfil,
          children: <TextSpan>[
            TextSpan(text: answer, style: respostaPerfil),
          ]));
}

ClipRRect imagemClipRRect(String? imageUrl, {double? size = 250.0}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10.0),
    child: imageUrl != null
        ? Image.network(
            imageUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
          )
        : Container(
            color: Colors.grey,
            width: size,
            height: size,
            child: Image.asset(imagemPadraoAsset),
          ),
  );
}

ListTile wifiOff({required String mensagem}) {
  return ListTile(
    tileColor: Colors.blueGrey,
    leading: const Icon(
      Icons.wifi_off,
      color: AppColors.claro,
    ),
    title: Text(
      mensagem.toString(),
      style: const TextStyle(color: AppColors.claro),
    ),
    titleAlignment: ListTileTitleAlignment.center,
  );
}

Image imagemLogo() {
  return Image.asset(
    'images/codelink_alt.png',
    height: 96,
    color: AppColors.verde,
  );
}

Expanded noData({String msg = 'Dados não encontrados!'}) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.data_object_outlined,
          size: 96,
          weight: 0.5,
          color: Colors.grey[700],
        ),
        Text(msg),
      ],
    ),
  );
}

String statusTranslate({required bool status}) {
  return (status) ? 'Conectado' : 'Desconectado';
}

bool isDesktop() {
  //debugPrint(Platform.operatingSystem);
  return (Platform.isWindows) ? true : false;
}

ButtonStyle iconeZoom(){
  return ButtonStyle(
    foregroundColor: WidgetStateProperty.all(AppColors.claro),
    backgroundColor: WidgetStateProperty.all(AppColors.verde),
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))
  );
}

IconData iconDevice(String tipo) {
  if (tipo.contains('Pulseira')) return Icons.watch_outlined;
  if (tipo.contains('Crachá')) return Icons.badge_outlined;
  return Icons.sell_outlined;
}

String pegaImagem(String tipo) {
  if (tipo == 'Crachá') {
    return 'cracha.png';
  } else if (tipo == 'Pulseira') {
    return 'pulseira.png';
  } else {
    return 'etiqueta.png';
  }
}

Color? getCor(int index) {
  switch (index % 2) {
    case 0:
      return Colors.blueGrey[100];
    case 1:
      return AppColors.claro;
    default:
      return Colors.blueGrey[100 * (index + 1)];
  }
}