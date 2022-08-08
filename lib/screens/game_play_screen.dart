import 'package:axie_scholarship/game.dart';
import 'package:axie_scholarship/models/setting_score.dart';
import 'package:flame/game.dart';
import 'package:flutter/src/widgets/framework.dart';

Game2048 _game2048 = Game2048(rows: 4, cols: 4);

class GamePlayScreen extends StatelessWidget {
  final SettingsAndScoreModel settingsAndScoreModel;
  const GamePlayScreen({
    Key? key,
    required this.settingsAndScoreModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _game2048);
  }
}
