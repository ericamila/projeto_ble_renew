import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:projeto_ble_renew/pages/device_vinculate.dart';
import 'package:projeto_ble_renew/pages/forms/device.dart';
import 'package:projeto_ble_renew/pages/login_page.dart';
import 'package:projeto_ble_renew/util/constants.dart';
import 'bluetooth/flutter_blue_app.dart';
import 'pages/home_page.dart';
import 'util/banco.dart';
import 'util/my_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'util/splash.dart';

class ConnectionNotifier extends InheritedNotifier<ValueNotifier<bool>> {
  const ConnectionNotifier(
      {super.key, required super.notifier, required super.child});

  //Verifica a conexão com internet
  static ValueNotifier<bool> of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ConnectionNotifier>()!
        .notifier!;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);

  if (!isWindows()) {
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  }

  final hasConnection =
      (kIsWeb) ? null : await InternetConnectionChecker().hasConnection;


  if (kIsWeb) {
    runApp(const App());
  } else {
    runApp(ConnectionNotifier(
      notifier: ValueNotifier(hasConnection!),
      child: const App(),
    ));
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final StreamSubscription<InternetConnectionStatus> listener;

  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      final notifier = ConnectionNotifier.of(context);
      notifier.value =
          status == InternetConnectionStatus.connected ? true : false;
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Codelink',
      theme: theme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/bluetooth': (context) => const FlutterBlueApp(),
        '/form_device': (context) => const FormCadastroDispositivo(),
        '/vinculate_device': (context) => const VincularDispositivos(),
      },
    );
  }
}
