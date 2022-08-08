import 'package:axie_scholarship/enums/movingDirection.dart';
import 'package:axie_scholarship/models/tileModel.dart';
import 'package:axie_scholarship/shared/gameColors.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class GameTile extends PositionComponent implements SizeProvider {
  TileModel tileModel;
  late TextPaint textPaint;
  EffectController moveEffectController = EffectController(duration: .1),
      scaleEffectController = EffectController(duration: .1);
  GameTile(
      {required Vector2 size,
      required this.tileModel,
      required Vector2 tilePosition})
      : super(anchor: Anchor.center, position: tilePosition, size: size) {
    this.updateColors();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
            Radius.circular(size.x * .07)),
        Paint()..color = tileColors[tileModel.value]!);
    if (this.tileModel.value != 0)
      textPaint.render(canvas, tileModel.value.toString(), Vector2.zero(),
          anchor: Anchor.center);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void updateColors() {
    this.textPaint = TextPaint(
        style: TextStyle(
            fontSize: size.x * .5,
            color: [2, 4].contains(tileModel.value)
                ? textColors[2]!
                : Colors.white));
  }

  Future<bool> mergeWithTile(
      {required MovingDirection movingDirection,
      required GameTile gameTile,
      required VoidCallback onMerging}) async {
    if (tileModel.merged == false &&
            gameTile.tileModel.merged == false &&
            tileModel.value == gameTile.tileModel.value ||
        tileModel.value == 0) {
      print("${tileModel.value} ${gameTile.tileModel.value}");
      print(tileModel.merged == false &&
          gameTile.tileModel.merged == false &&
          tileModel.value == gameTile.tileModel.value);
      await gameTile.moveTile(
          direction: movingDirection,
          onCompleted: () {
            updateColors();
            gameTile.updateColors();
            this.addScaleEffect();
          });
      print("merging is complete");
      onMerging();
      return this.tileModel.merge(tileModel: gameTile.tileModel);
    }
    return false;
  }

  Future<void> moveTile(
      {required MovingDirection direction,
      required VoidCallback onCompleted}) async {
    Vector2 oldPosition = this.position.clone(), moveRatio;
    switch (direction) {
      case MovingDirection.Right:
        moveRatio = Vector2(width * .2, 0);
        break;
      case MovingDirection.Left:
        moveRatio = Vector2(-width * .2, 0);
        break;
      case MovingDirection.Down:
        moveRatio = Vector2(0, height * .2);
        break;
      default:
        moveRatio = Vector2(0, -height * .2);
        break;
    }
    MoveEffect moveEffect =
        MoveByEffect(moveRatio, moveEffectController, onComplete: () {
      // print("old positions is ${this.position.toString()}");
      this.position = oldPosition;
      onCompleted();
      moveEffectController.setToStart();
    });
    await this.add(moveEffect);
  }

  Future<void> addScaleEffect() async {
    Vector2 originalSize = this.size.clone();
    SizeEffect sizeEffect =
        SizeEffect.to(this.size * 1.07, scaleEffectController, onComplete: () {
      scaleEffectController.setToStart();
      this.add(SizeEffect.to(
        originalSize,
        scaleEffectController,
      ));
    });
    scaleEffectController.setToStart();
    await this.add(sizeEffect);
    return;
  }

  bool isEmpty() => tileModel.isEmpty();
  void reset() => tileModel.reset();
}
