import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final FirebaseDatabase _database = FirebaseDatabase.instance;

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  void addContato(){
  }

  void addContatoDialog(){

  }
}