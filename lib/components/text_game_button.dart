import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_2048/game.dart';

class TextGameButton extends TextComponent with Tappable {
  final Paint paint = Paint();
  VoidCallback onTap;
  String buttonText;
  Color buttonColor, textColor;
  double fontSize;
  Vector2 buttonSize;
  TextGameButton({
    required this.buttonSize,
    required this.fontSize,
    required this.onTap,
    required this.buttonText,
    required Vector2 position,
    required this.buttonColor,
    required this.textColor,
  }) : super(position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    paint.color = buttonColor;
    this.text = buttonText;
    this.textRenderer = TextPaint(
        style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            fontFamily: "Rubik"));
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(width * .5, height * .5),
            width: buttonSize.x,
            height: buttonSize.y),
        Radius.circular(10),
      ),
      paint,
    );
    return super.render(canvas);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    onTap();
    return super.onTapDown(info);
  }
}
