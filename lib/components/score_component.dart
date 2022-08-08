import 'package:axie_scholarship/game.dart';
import 'package:flame/components.dart';

class ScoreComponent extends TextComponent implements HasGameRef<Game2048> {
  @override
  // TODO: implement gameRef
  Game2048 get gameRef => throw UnimplementedError();

  @override
  void mockGameRef(Game2048 gameRef) {
    // TODO: implement mockGameRef
  }
}
