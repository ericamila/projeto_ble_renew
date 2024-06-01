import 'package:flutter/material.dart';
import 'package:projeto_ble_renew/components/drawer_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onUserTap;
  final void Function()? onAboutTap;
  final void Function()? onSignOut;

  const MyDrawer(
      {super.key,
      required this.onProfileTap,
      required this.onSignOut,
      required this.onUserTap,
      required this.onAboutTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF008296),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Image.asset(
                  'images/codelink_alt.png',
                  color: Color(0xFFF9FDFE),
                  height: 64,
                ),
              ),
              //home list tile
              DrawerListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: () => Navigator.pop(context),
              ),
              //profile list tile
              DrawerListTile(
                  icon: Icons.account_circle,
                  text: 'P R O F I L E',
                  onTap: onProfileTap),
              DrawerListTile(
                  icon: Icons.manage_accounts,
                  text: 'U S U Á R I O S',
                  onTap: onUserTap),
              DrawerListTile(
                  icon: Icons.info, text: 'S O B R E', onTap: onAboutTap),
            ],
          ),
          //logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: DrawerListTile(
              icon: Icons.logout,
              text: 'L O G O U T',
              onTap: onSignOut,
            ),
          ),
        ],
      ),
    );
  }
}
