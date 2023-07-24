import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nossa_lista_de_compras/hidden_drawer.dart';
import 'package:nossa_lista_de_compras/pages/login_page.dart';

class MainPage extends StatelessWidget{
  const MainPage({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return HiddenDrawer();
          } else {
            return LoginPage();
          }
        }
      ),
    );
  }
}