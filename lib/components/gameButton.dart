import 'package:axie_scholarship/enums/movingDirection.dart';
import 'package:axie_scholarship/game.dart';
import 'package:axie_scholarship/shared/gameColors.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

class GameButton extends PositionComponent with Tappable, HasGameRef<Game2048> {
  final Paint paint = Paint()..color = bgColor;
  GameButton({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(width * .5, height * .5),
            width: width,
            height: height),
        Radius.circular(10),
      ),
      paint,
    );
  }

  @override
  bool onTapDown(TapDownInfo info) {
    print("Button Right is tapped");
    gameRef.gameModel.merge(mergingDirection: MovingDirection.Down);
    return super.onTapDown(info);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print("Button right on tap up");
    return super.onTapUp(info);
  }
}
