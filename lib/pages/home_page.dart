import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import '../util/constants.dart';
import 'menu/device.dart';
import 'menu/map.dart';
import 'menu/register.dart';
import 'menu/search.dart';
import '../components/drawer.dart';
import '../util/app_cores.dart';
import '../util/banco.dart';
import '../util/my_theme.dart';
import 'menu/alarme.dart';

class HomePage extends StatefulWidget {
  int? page;

  HomePage({this.page, super.key});

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
    Navigator.pushNamed(context, '/profile');
  }

  //navigate to User page
  void goToUserPage() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/list_users');
  }

  //navigate to User page
  void goToAboutPage() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/about');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.page == 3) _page = 3;
    widget.page = null;
    return Scaffold(
      appBar: AppBar(
        title: isDesktop()
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
      body: isDesktop()
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
      bottomNavigationBar: isDesktop()
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
