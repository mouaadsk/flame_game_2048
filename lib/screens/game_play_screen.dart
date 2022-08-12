import 'package:game_2048/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Game2048 _game2048 = Game2048(rows: 4, cols: 4);

class GamePlayScreen extends StatelessWidget {
  const GamePlayScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
          onWillPop: () async {
            await Get.offNamed("/home");
            return true;
          },
          child: GameWidget(game: _game2048)),
    );
  }
}
