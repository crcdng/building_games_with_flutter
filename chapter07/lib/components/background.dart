import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../main.dart';
import 'george.dart';

class Background extends PositionComponent
    with TapCallbacks, HasGameReference<GoldRush> {
  Background(this.george);

  final George george;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    position = Vector2(0, 0);
    size = Vector2(
        game.mapSize.x, game.mapSize.y); // size of the map (not of the screen)
  }

  @override
  bool onTapUp(TapUpEvent event) {
    george.moveToLocation(event.canvasPosition);
    return true;
  }
}
