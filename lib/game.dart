import 'package:axie_scholarship/components/background.dart';
import 'package:axie_scholarship/components/gameButton.dart';
import 'package:axie_scholarship/enums/movingDirection.dart';
import 'package:axie_scholarship/models/gameModel.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class Game2048 extends FlameGame with PanDetector {
  late GameModel gameModel;
  final int cols, rows;
  Game2048({
    required this.rows,
    required this.cols,
  });

  late GameButton rightButton;
  late GameBackground bg;
  late Vector2 bgTopLeftCorner;
  bool swipingInTiles = false;
  @override
  Future<void> onLoad() async {
    bg = GameBackground(
        center: Vector2(size.x * .5, size.y * .5),
        size: Vector2(size.x * .9, size.x * .9));
    await add(bg);
    bgTopLeftCorner = bg.center + Vector2(-bg.size.x * .5, -bg.size.y * .5);
    gameModel = GameModel(cols: cols, rows: rows, gameRef: this);
    await gameModel.addTileToGame();
    rightButton = GameButton(
        position: Vector2(size.x * .5, size.y * .8), size: Vector2(100, 100));
    // await add(rightButton);
    print("Tiles are added");
    return super.onLoad();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    super.onPanEnd(info);
    if (swipingInTiles) {
      if (info.velocity.x.abs() > info.velocity.y.abs()) {
        if (info.velocity.x < 0)
          gameModel.merge(mergingDirection: MovingDirection.Left);
        else
          gameModel.merge(mergingDirection: MovingDirection.Right);
      } else {
        if (info.velocity.y < 0)
          gameModel.merge(mergingDirection: MovingDirection.Up);
        else
          gameModel.merge(mergingDirection: MovingDirection.Down);
      }
      swipingInTiles = false;
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    super.onPanUpdate(info);
    if (info.eventPosition.game.x >= bgTopLeftCorner.x &&
        info.eventPosition.game.x < bgTopLeftCorner.x + bg.size.x &&
        info.eventPosition.game.y > bgTopLeftCorner.y &&
        info.eventPosition.game.y < bgTopLeftCorner.y + bg.size.y)
      swipingInTiles = true;
    // print("On Pan update called : ${info.eventPosition.game}");
  }
}
