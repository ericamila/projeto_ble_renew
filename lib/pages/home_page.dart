import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import '../util/constants.dart';
import 'drawer/drawer_list_user.dart';
import 'drawer/drawer_profile.dart';
import 'menu/device.dart';
import 'menu/mapx.dart';
import 'menu/register.dart';
import 'menu/search.dart';
import '../components/drawer.dart';
import '../util/app_cores.dart';
import '../util/banco.dart';
import '../util/my_theme.dart';
import 'drawer/drawer_about.dart';
import 'menu/alarme.dart';

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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Sobre()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isWindows()
            ? const Padding(
                padding: EdgeInsets.only(left: 210),
                child: Text("Codelink"),
              )
            : const Text("Codelink"),
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
      body: isWindows()
          ? Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    backgroundColor: AppColors.escuro,
                    extended: true,
                    selectedIndex: _page,
                    minExtendedWidth: 210,
                    onDestinationSelected: (index) {
                      setState(() {
                        _page = index;
                      });
                    },
                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: Icon(
                          Icons.home_outlined,
                          color: AppColors.verdeBotao,
                        ),
                        label: Text('Início', style: estiloLabelRail),
                      ),
                      NavigationRailDestination(
                        icon: Icon(
                          Icons.bluetooth,
                          color: AppColors.verdeBotao,
                        ),
                        label: Text('Dispositivos', style: estiloLabelRail),
                      ),
                      NavigationRailDestination(
                        icon: Icon(
                          Icons.search,
                          color: AppColors.verdeBotao,
                        ),
                        label: Text('Busca', style: estiloLabelRail),
                      ),
                      NavigationRailDestination(
                        icon: Icon(
                          Icons.map_outlined,
                          color: AppColors.verdeBotao,
                        ),
                        label: Text('Mapa', style: estiloLabelRail),
                      ),
                      NavigationRailDestination(
                        icon: Icon(
                          Icons.create_new_folder_outlined,
                          color: AppColors.verdeBotao,
                        ),
                        label: Text('Cadastros', style: estiloLabelRail),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _pages[_page],
                )
              ],
            )
          : _pages[_page],
      bottomNavigationBar: isWindows()
          ? null
          : CurvedNavigationBar(
              backgroundColor: AppColors.claro,
              color: AppColors.escuro,
              buttonBackgroundColor: AppColors.verde,
              onTap: (index) {
                setState(() {
                  _page = index;
                });
              },
              items: const [
                CurvedNavigationBarItem(
                  child: Icon(
                    Icons.home_outlined,
                    color: AppColors.claro,
                  ),
                  label: 'Início',
                  labelStyle: estiloLabelCurvedBarItem,
                ),
                CurvedNavigationBarItem(
                  child: Icon(
                    Icons.bluetooth,
                    color: AppColors.claro,
                  ),
                  label: 'Dispositivos',
                  labelStyle: estiloLabelCurvedBarItem,
                ),
                CurvedNavigationBarItem(
                  child: Icon(
                    Icons.search,
                    color: AppColors.claro,
                  ),
                  label: 'Busca',
                  labelStyle: estiloLabelCurvedBarItem,
                ),
                CurvedNavigationBarItem(
                  child: Icon(
                    Icons.map_outlined,
                    color: AppColors.claro,
                  ),
                  label: 'Mapa',
                  labelStyle: estiloLabelCurvedBarItem,
                ),
                CurvedNavigationBarItem(
                  child: Icon(
                    Icons.create_new_folder_outlined,
                    color: AppColors.claro,
                  ),
                  label: 'Cadastros',
                  labelStyle: estiloLabelCurvedBarItem,
                ),
              ],
            ),
    );
  }
}
