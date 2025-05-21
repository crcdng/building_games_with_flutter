import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:goldrush/main.dart';

class Player extends PositionComponent
    with CollisionCallbacks, HasGameReference<GoldRush> {
  static const int squareSpeed = 250; // The speed that our square will animate
  static final squarePaint =
      BasicPalette.green.paint(); // The color of the square
  static final squareWidth = 100.0,
      squareHeight =
          100.0; // The width and height of our square will be 100 x 100

  // The direction our square is travelling in, 1 for left to right, -1 for right to left
  int squareDirection = 1;
  late double screenWidth, screenHeight, centerX, centerY;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Get the width and height of our screen canvas
    screenWidth = game.size.x;
    screenHeight = game.size.y;

    size = Vector2(squareWidth, squareHeight); // necessary
    anchor = Anchor.center;
    position = Vector2(screenWidth / 2, screenHeight / 2);
    add(RectangleHitbox()..renderShape = true);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ScreenHitbox) {
      if (squareDirection == 1) {
        squareDirection = -1;
      } else {
        squareDirection = 1;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += squareSpeed * squareDirection * dt;
  }

  // only the hitbox is rendered (see onLoad))
}
