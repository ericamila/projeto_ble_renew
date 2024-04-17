import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum SnackEnum {
  a,
  b,
  c,
}

class Snackbar {
  static final snackBarKeyA = GlobalKey<ScaffoldMessengerState>();
  static final snackBarKeyB = GlobalKey<ScaffoldMessengerState>();
  static final snackBarKeyC = GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> getSnackbar(SnackEnum abc) {
    switch (abc) {
      case SnackEnum.a:
        return snackBarKeyA;
      case SnackEnum.b:
        return snackBarKeyB;
      case SnackEnum.c:
        return snackBarKeyC;
    }
  }

  static show(SnackEnum abc, String msg, {required bool success}) {
    final snackBar = success
        ? SnackBar(content: Text(msg), backgroundColor: Colors.blue[200])
        : SnackBar(content: Text(msg), backgroundColor: Colors.red[200]);
    getSnackbar(abc).currentState?.removeCurrentSnackBar();
    getSnackbar(abc).currentState?.showSnackBar(snackBar);
  }
}


String prettyException(String prefix, dynamic e) {
  if (e is FlutterBluePlusException) {
    return "$prefix ${e.description}";
  } else if (e is PlatformException) {
    return "$prefix ${e.message}";
  }
  return prefix + e.toString();
}
