import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'components/hud/hud.dart';
import 'components/zombie.dart';
import 'components/skeleton.dart';
import 'components/background.dart';
import 'components/george.dart';

void main() async {
  // Create an instance of the game
  final goldRush = GoldRush();

  // Setup Flutter widgets and start the game in full screen portrait orientation
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  // Run the app, passing the games widget here
  runApp(GameWidget(game: goldRush));
}

class GoldRush extends FlameGame with HasCollisionDetection {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    // NOTE in order to position elements inside the HudComponent it must get the size of the viewport
    var hud = HudComponent()..size = size;
    var george = George(
        hud: hud,
        position: Vector2(200, 400),
        size: Vector2(48.0, 48.0),
        speed: 40.0);
    world.add(Background(george));
    world.add(george);
    world.add(Zombie(
        position: Vector2(100, 200), size: Vector2(32.0, 64.0), speed: 20.0));
    world.add(Zombie(
        position: Vector2(300, 200), size: Vector2(32.0, 64.0), speed: 20.0));
    world.add(Skeleton(
        position: Vector2(100, 500), size: Vector2(32.0, 64.0), speed: 60.0));
    world.add(Skeleton(
        position: Vector2(300, 500), size: Vector2(32.0, 64.0), speed: 60.0));
    world.add(ScreenHitbox());
    camera.viewfinder.add(hud);
  }
}
