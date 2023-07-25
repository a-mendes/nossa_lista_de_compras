import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim()
      );
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
                    'Um email para recuperação de senha foi enviado para '
                        + _emailController.text.trim() +
                        '. Consulte sua caixa de entrada')
            );
          }
      );
    } on FirebaseAuthException catch(e){
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: Text("Recuperar Senha"),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              'Informe o email cadastrado na sua conta para prosseguir com a recuperação de senha',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18
              ),
            ),
          ),

          SizedBox(height: 10),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email"
                    ),
                  )
              ),
            ),
          ),

          SizedBox(height: 10),
          MaterialButton(
            onPressed: passwordReset,
            child: Text('Recuperar Senha', style: TextStyle(color: Colors.white),),
            color: Colors.deepPurple.shade400,
          )
        ],
      ),
    );
  }
}
