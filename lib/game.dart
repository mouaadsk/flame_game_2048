import 'package:flame/extensions.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:game_2048/components/background.dart';
import 'package:game_2048/components/gameButton.dart';
import 'package:game_2048/components/score_component.dart';
import 'package:game_2048/components/text_game_button.dart';
import 'package:game_2048/enums/movingDirection.dart';
import 'package:game_2048/enums/score_type.dart';
import 'package:game_2048/models/gameModel.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:game_2048/shared/app_audios.dart';
import 'package:game_2048/shared/gameColors.dart';

class Game2048 extends FlameGame with PanDetector, HasTappables {
  late GameModel gameModel;
  final int cols, rows;
  late TextGameButton newGameButton;
  late Map<int, AudioPool> sfxPool = Map<int, AudioPool>();
  Game2048({
    required this.rows,
    required this.cols,
  });
  late GameButton rightButton, leftButton, upButton, downButton;
  late GameBackground bg;
  late Vector2 bgTopLeftCorner;
  bool swipingInTiles = false;
  double buttonSidelength = 70.0;
  late ScoreComponent currentScoreComponent;
  @override
  Future<void> onLoad() async {
    // final audioPlayers = await FlameAudio.play('16.mp3');
    gameSounds.forEach(
      (key, value) async {
        sfxPool[key] = await AudioPool.create("audio/$value", maxPlayers: 6);
      },
    );
    print("Audios are loaded");
    bg = GameBackground(
        center: Vector2(size.x * .5, size.y * .45),
        size: Vector2(size.x * .9, size.x * .9));
    await add(bg);
    bgTopLeftCorner = bg.center + Vector2(-bg.size.x * .5, -bg.size.y * .5);
    gameModel = GameModel(cols: cols, rows: rows, gameRef: this);
    await gameModel.addTileToGame();
    rightButton = GameButton(
        position: Vector2(size.x * .6 + buttonSidelength * .75, size.y * .8),
        size: Vector2.all(buttonSidelength),
        mergingDirection: MovingDirection.Right,
        assetLocation: "png/right-arrow.png",
        spriteSize: Vector2(22.0, 42.0));
    leftButton = GameButton(
        position: Vector2(
            size.x * .4 + buttonSidelength * .75 - buttonSidelength * 1.5,
            size.y * .8),
        size: Vector2.all(buttonSidelength),
        spriteSize: Vector2(22.0, 42.0),
        mergingDirection: MovingDirection.Left,
        assetLocation: "png/left-arrow.png");
    upButton = GameButton(
        position: Vector2(
            size.x * .5 + buttonSidelength * .75 - buttonSidelength * .75,
            size.y * .85 - buttonSidelength * 1.1),
        size: Vector2.all(buttonSidelength),
        spriteSize: Vector2(42.0, 22.0),
        mergingDirection: MovingDirection.Up,
        assetLocation: "png/up-arrow.png");
    downButton = GameButton(
        position: Vector2(
            size.x * .5 + buttonSidelength * .75 - buttonSidelength * .75,
            size.y * .77 + buttonSidelength * 1.1),
        size: Vector2.all(buttonSidelength),
        spriteSize: Vector2(42.0, 22.0),
        mergingDirection: MovingDirection.Down,
        assetLocation: "png/down-arrow.png");
    currentScoreComponent = ScoreComponent(
        position: Vector2(size.x * .27, size.y * .16),
        scoreType: ScoreType.TotalScore);
    newGameButton = TextGameButton(
        buttonSize: Vector2(size.x * .5, size.x * .16),
        fontSize: size.x * .07,
        onTap: gameModel.newGame,
        buttonText: "New Game",
        position: Vector2(size.x * .5, size.y * .07),
        buttonColor: appBrownyOrange,
        textColor: appTextColor1);
    await add(rightButton);
    await add(leftButton);
    await add(upButton);
    await add(downButton);
    await add(currentScoreComponent);
    await add(ScoreComponent(
        position: Vector2(size.x * .7, size.y * .16),
        scoreType: ScoreType.MaxTile));
    await add(newGameButton);
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

  @override
  Color backgroundColor() => appMainColor;
}
