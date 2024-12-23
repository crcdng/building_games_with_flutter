import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:goldrush/components/george.dart';
import 'package:goldrush/utils/math_utils.dart';

class Background extends PositionComponent with TapCallbacks {
  Background(this.george) : super(priority: 20);

  final George george;

  @override
  bool onTapUp(TapUpEvent event) {
    george.moveToLocation(event.canvasPosition, event.localPosition);
    return true;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    Rect gameScreenBounds = getGameScreenBounds(size);
    if (size.x > 1600) {
      double xAdjust = (size.x - 1600) / 2;
      position = Vector2(gameScreenBounds.left + xAdjust, gameScreenBounds.top);
    } else {
      position = Vector2(gameScreenBounds.left, gameScreenBounds.top);
    }
    size = Vector2(1600, 1600);
  }
}
