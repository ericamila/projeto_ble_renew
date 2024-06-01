import 'package:flutter/material.dart';

import 'app_cores.dart';
import 'constants.dart';

const TextStyle estiloLabelCurvedBarItem = TextStyle(
    fontWeight: FontWeight.normal, fontSize: 12, color: AppColors.verde);

const TextStyle estiloLabelRail = TextStyle(
    fontWeight: FontWeight.normal, fontSize: 15, color: AppColors.claro);

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
  useMaterial3: true,
/*
AppBar
 */
  appBarTheme: const AppBarTheme(
      color: AppColors.escuro,
      centerTitle: true,
      foregroundColor: AppColors.verde,
      titleTextStyle: TextStyle(color: AppColors.claro, fontSize: 22)),
/*
ElevatedButton
 */
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.verdeBotao,
        foregroundColor: AppColors.claro,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
  ),
/*
FilledButton
 */
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size(300, 45)),
      maximumSize: WidgetStateProperty.all(const Size(500, 60)),
      padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
      textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 20)),
      shape:
          WidgetStateProperty.all<RoundedRectangleBorder>(borderRadiusPadrao),
    ),
  ),
/*
FloatingActionButton
 */
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.verdeBotao,
    foregroundColor: AppColors.claro,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
/*
Scaffold
 */
  scaffoldBackgroundColor: AppColors.claro,
);
