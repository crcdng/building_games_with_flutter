import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:goldrush/main.dart';
import 'george.dart';
import 'package:goldrush/utils/math_utils.dart';
import 'dart:ui';

class Background extends PositionComponent
    with TapCallbacks, HasGameRef<GoldRush> {
  Background(this.george) : super(priority: 20);

  final George george;

  @override
  bool onTapUp(TapUpEvent event) {
    george.moveToLocation(event.canvasPosition);
    return true;
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    Rect gameScreenBounds = getGameScreenBounds(canvasSize);
    if (canvasSize.x > game.mapSize.x) {
      double xAdjust = (canvasSize.x - game.mapSize.x) / 2;
      position = Vector2(gameScreenBounds.left + xAdjust, gameScreenBounds.top);
    } else {
      position = Vector2(gameScreenBounds.left, gameScreenBounds.top);
    }
    size = Vector2(game.mapSize.x, game.mapSize.y);
  }
}
