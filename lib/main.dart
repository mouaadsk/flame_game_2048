import 'package:axie_scholarship/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final game2048 = Game2048(cols: 4, rows: 4);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game 2048',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameWidget(game: game2048),
    );
  }
}
