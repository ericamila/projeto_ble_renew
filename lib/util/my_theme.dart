import 'package:flutter/material.dart';

import 'app_cores.dart';
import 'constants.dart';

const TextStyle estiloLabelCurvedBarItem =
    TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: verde);

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
  useMaterial3: true,
/*
AppBar
 */
  appBarTheme: const AppBarTheme(
      color: escuro,
      centerTitle: true,
      foregroundColor: verde,
      titleTextStyle: TextStyle(color: claro, fontSize: 22)),
/*
FilledButton
 */
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(300, 45)),
      maximumSize: MaterialStateProperty.all(const Size(500, 60)),
      padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 20)),
      shape:
          MaterialStateProperty.all<RoundedRectangleBorder>(borderRadiusPadrao),
    ),
  ),
/*
ElevatedButton
 */
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: verdeBotao,
        foregroundColor: claro,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
  ),
/*
FloatingActionButton
 */
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: verdeBotao,
      foregroundColor: claro,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
/*
Scaffold
 */
  scaffoldBackgroundColor: claro,
);
