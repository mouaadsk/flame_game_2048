import 'package:axie_scholarship/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game 2048',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(fontFamily: "Rubik"),
      home: MainMenuScreen(),
    );
  }
}
