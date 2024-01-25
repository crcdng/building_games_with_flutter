import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class Coin extends SpriteAnimationComponent with CollisionCallbacks {
  Coin({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    var spriteImages = await Flame.images.load('coins.png');
    final spriteSheet = SpriteSheet(image: spriteImages, srcSize: size);

    animation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 7);

    // DEPRECATED collidableType = CollidableType.passive;
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}
