import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_akhir/views/favorit.dart';
import 'package:project_akhir/views/login.dart';


Future<void> main() async {

  await Hive.initFlutter();
  // Hive.registerAdapter(Favorit());
  await Hive.openBox('users');
  await Hive.openBox<Favorit>('Favorit');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        )
      ),
      home: LoginPage(),
    );
  }
}