import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'dart:ui';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'george.dart';

class Background extends PositionComponent
    with HasGameReference<GoldRush>, TapCallbacks {
  Background(this.george);

  final George george;

  static final backgroundPaint =
      BasicPalette.white.paint(); // The color of the background
  late double screenWidth, screenHeight;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Get the width and height of our screen canvas
    screenWidth = game.size.x;
    screenHeight = game.size.y;

    position = Vector2(0, 0);
    size = Vector2(screenWidth, screenHeight);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRect(
        Rect.fromLTWH(0.0, 0.0, screenWidth, screenHeight), backgroundPaint);
  }

  @override
  bool onTapUp(TapUpEvent event) {
    george.moveToLocation(event.canvasPosition);
    return true;
  }
}
