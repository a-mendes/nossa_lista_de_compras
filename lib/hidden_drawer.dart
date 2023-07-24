import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
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
              baseStyle: TextStyle(),
              selectedStyle: TextStyle()),
          HomePage()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: 'Profile',
              baseStyle: TextStyle(),
              selectedStyle: TextStyle()),
          ProfilePage())
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
