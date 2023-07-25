import 'package:flutter/material.dart';
import 'package:nossa_lista_de_compras/pages/login_page.dart';
import 'package:nossa_lista_de_compras/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool showingLoginPage = true;

  void toggleScreens() {
    setState(() {
      showingLoginPage = !showingLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showingLoginPage)
      return LoginPage(showRegisterPage: toggleScreens);

    else
      return RegisterPage(showLoginPage: toggleScreens);
  }
}
