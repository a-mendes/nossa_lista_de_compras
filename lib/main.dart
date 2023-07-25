import 'package:flutter/material.dart';
import 'package:nossa_lista_de_compras/api/firebase_application_interface.dart';
import 'package:nossa_lista_de_compras/custom_notification.dart';

import 'package:nossa_lista_de_compras/pages/main_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final FirebaseDatabase _database = FirebaseDatabase.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationService>(create: (context) => NotificationService())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nossa Lista de Compras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: MainPage(),
    );
  }
}
