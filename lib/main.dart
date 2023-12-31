import 'package:flutter/material.dart';
import 'package:nossa_lista_de_compras/pages/main_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nossa_lista_de_compras/services/firebase_messaging_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000); // Define o tamanho máximo do cache local

  runApp(
      MultiProvider(
        providers: [
          Provider<NotificationService>(create: (context) => NotificationService()),
          Provider<FirebaseMessagingService>(create: (context) => FirebaseMessagingService(context.read<NotificationService>()))
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
