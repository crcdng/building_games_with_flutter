import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'character_enemy.dart';

class Skeleton extends EnemyCharacter {
  Skeleton(
      {required super.position, required super.size, required super.speed});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    var spriteImages = await Flame.images.load('zombie_n_skeleton.png');
    final spriteSheet = SpriteSheet(image: spriteImages, srcSize: size);

    downAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 3, to: 5);
    leftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: 0.2, from: 3, to: 5);
    upAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: 0.2, from: 3, to: 5);
    rightAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: 0.2, from: 3, to: 5);

    changeDirection();

    // DEPRECATED add(RectangleHitbox(relation: Vector2(1.0, 0.7))..relativeOffset = Vector2(0.0, 0.3));
    add(RectangleHitbox.relative(Vector2(1.0, 0.67),
        parentSize: size, position: Vector2(0.0, 20.0)));
  }
}
