import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/pages/drawer_list_usuario.dart';
import 'package:projeto_ble_renew/pages/menu_search.dart';
import '../components/drawer.dart';
import '../util/app_cores.dart';
import '../util/banco.dart';
import '../util/my_theme.dart';
import 'drawer_about.dart';
import 'drawer_profile.dart';
import 'menu_alarme.dart';
import 'menu_device.dart';
import 'menu_map.dart';
import 'menu_register.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;

  final List<Widget> _pages = [
    const MenuAlarme(),
    const MenuDispositivo(),
    const MenuPesquisa(),
    const MenuMapa(),
    const MenuCadastro(),
  ];

  //LogOut
  Future<void> signOut() async {
    await supabase.auth.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  //navigate to Profile page
  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ));
  }

  //navigate to User page
  void goToUserPage() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Usuarios(),
        ));
  }
  //navigate to User page
  void goToAboutPage() {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const Sobre()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Codelink"),
        actions: [
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onUserTap: goToUserPage,
        onAboutTap: goToAboutPage,
        onSignOut: signOut,
      ),
      body: _pages[_page],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: claro,
        color: escuro,
        buttonBackgroundColor: verde,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        items: const [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home_outlined,
              color: claro,
            ),
            label: 'Início',
            labelStyle: estiloLabelCurvedBarItem,
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.bluetooth,
              color: claro,
            ),
            label: 'Dispositivos',
            labelStyle: estiloLabelCurvedBarItem,
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.search,
              color: claro,
            ),
            label: 'Busca',
            labelStyle: estiloLabelCurvedBarItem,
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.map_outlined,
              color: claro,
            ),
            label: 'Mapa',
            labelStyle: estiloLabelCurvedBarItem,
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.create_new_folder_outlined,
              color: claro,
            ),
            label: 'Cadastros',
            labelStyle: estiloLabelCurvedBarItem,
          ),
        ],
      ),
    );
  }
}
