import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'character_enemy.dart';

class Zombie extends EnemyCharacter {
  Zombie(
      {required super.player,
      required Vector2 position,
      required super.size,
      required super.speed})
      : super(position: position) {
    originalPosition = position;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    var spriteImages = await Flame.images.load('zombie_n_skeleton.png');
    final spriteSheet = SpriteSheet(image: spriteImages, srcSize: size);

    downAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 0, to: 2);
    leftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: 0.2, from: 0, to: 2);
    upAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: 0.2, from: 0, to: 2);
    rightAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: 0.2, from: 0, to: 2);

    changeDirection();

    add(RectangleHitbox.relative(Vector2(1.0, 0.6),
        parentSize: size, position: Vector2(0.0, 25.0)));
  }
}
