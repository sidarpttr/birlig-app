import 'package:bir_lig_app/app.dart';
import 'package:bir_lig_app/constants/theme_constants.dart';
import 'package:bir_lig_app/presentation/screens/login.dart';
import 'package:bir_lig_app/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BirLig",
      theme: MyAppTheme.darkTheme,
      routes: {
        '/login':(context) => LoginPage(),
        '/home':(context) => const Home()
      },
      home: LoginPage(),
    );
  }
}
