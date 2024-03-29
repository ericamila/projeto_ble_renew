import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/pages/home.dart';
import 'package:projeto_ble_renew/util/banco.dart';
import 'package:projeto_ble_renew/util/my_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: anonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Codelink',
      theme: theme,
      home: const Home(),
    );
  }
}
