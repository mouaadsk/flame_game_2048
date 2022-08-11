import 'package:axie_scholarship/models/home_bindings.dart';
import 'package:axie_scholarship/screens/game_play_screen.dart';
import 'package:axie_scholarship/screens/main_menu_screen.dart';
import 'package:axie_scholarship/screens/sound_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Game 2048',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(fontFamily: "Rubik"),
      initialBinding: HomeBindings(),
      home: MainMenuScreen(),
      getPages: [
        GetPage(name: "/home", page: () => MainMenuScreen()),
        GetPage(name: "/play", page: () => GamePlayScreen()),
        GetPage(name: "/sound", page: () => SoundScreen())
      ],
    );
  }
}
