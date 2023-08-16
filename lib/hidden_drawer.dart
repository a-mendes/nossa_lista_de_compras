import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:nossa_lista_de_compras/pages/contact_page.dart';
import 'package:nossa_lista_de_compras/pages/home_page.dart';
import 'package:nossa_lista_de_compras/pages/profile_page.dart';

class HiddenDrawer extends StatefulWidget{
  const HiddenDrawer({Key? key}) : super(key:key);

  @override
  State<StatefulWidget> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer>{

  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'Home',
              baseStyle: const TextStyle(),
              selectedStyle: const TextStyle()),
          const HomePage()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'Contacts',
              baseStyle: const TextStyle(),
              selectedStyle: const TextStyle()),
          const ContactPage()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'Profile',
              baseStyle: const TextStyle(),
              selectedStyle: const TextStyle()),
          const ProfilePage())
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.deepPurple.shade200,
      screens: _pages,
      initPositionSelected: 0,
    );
  }

}
