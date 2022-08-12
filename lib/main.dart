import 'package:audioplayers/audioplayers.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:game_2048/models/home_bindings.dart';
import 'package:game_2048/screens/game_play_screen.dart';
import 'package:game_2048/screens/main_menu_screen.dart';
import 'package:game_2048/screens/sound_screen.dart';
import 'package:flutter/material.dart';
import 'package:game_2048/shared/app_audios.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:flame_audio/flame_audio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      onInit: () async {
        try {
          await FlameAudio.audioCache.loadAll([buttonClickSound]
            ..addAll(gameSounds.entries.map((e) => e.value).toList()));
        } catch (e) {
          print("Error : ${e.toString()}");
        }
      },
    );
  }
}
