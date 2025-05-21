import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../utils/math_utils.dart';

// to position tiles when the screen resizes.
class TileMapComponent extends PositionComponent
    with HasGameReference<GoldRush> {
  TileMapComponent(this.tiledComponent) {
    add(tiledComponent);
  }

  TiledComponent tiledComponent;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    Rect gameScreenBounds = getGameScreenBounds(size);
    if (size.x > game.mapSize.x) {
      double xAdjust = (size.x - game.mapSize.x) / 2;
      position = Vector2(gameScreenBounds.left + xAdjust, gameScreenBounds.top);
    } else {
      position = Vector2(gameScreenBounds.left, gameScreenBounds.top);
    }
    size = Vector2(game.mapSize.x, game.mapSize.y);
  }
}
