import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Water extends PositionComponent with CollisionCallbacks {
  Water({required Vector2 position, required Vector2 size, required this.id})
      : super(position: position, size: size);

  int id;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // DEPRECATED collidableType = CollidableType.passive;
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }
}
