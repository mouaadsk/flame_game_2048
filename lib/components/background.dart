import 'package:game_2048/game.dart';
import 'package:game_2048/shared/gameColors.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

class GameBackground extends Component with HasGameRef<Game2048> {
  final Vector2 center, size;

  GameBackground({
    required this.center,
    required this.size,
  });
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: this.center.toOffset(), width: size.y, height: size.x),
            Radius.circular(size.x * .03)),
        Paint()..color = bgColor);
  }
}
