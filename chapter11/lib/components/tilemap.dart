import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:goldrush/utils/math_utils.dart';

class TileMapComponent extends PositionComponent {
  TileMapComponent(this.tiledComponent) {
    add(tiledComponent);
  }

  TiledComponent tiledComponent;

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
