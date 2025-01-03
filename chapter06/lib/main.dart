import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'components/character.dart';
import 'components/hud/hud.dart';
import 'components/zombie.dart';
import 'components/skeleton.dart';
import 'components/background.dart';
import 'components/george.dart';
import 'package:flame_audio/flame_audio.dart';

void main() async {
  // Setup Flutter widgets and start the game in full screen portrait orientation
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  // Run the app, passing the games widget here
  runApp(GameWidget(game: GoldRush()));
}

class GoldRush extends FlameGame with HasCollisionDetection {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play('music/music.mp3', volume: 0.1);

    var hud = HudComponent()..size = size;
    var george = George(
        hud: hud,
        position: Vector2(200, 400),
        size: Vector2(48.0, 48.0),
        speed: 40.0);
    add(Background(george));
    add(george);
    add(Zombie(
        position: Vector2(100, 200), size: Vector2(32.0, 64.0), speed: 20.0));
    add(Zombie(
        position: Vector2(300, 200), size: Vector2(32.0, 64.0), speed: 20.0));
    add(Skeleton(
        position: Vector2(100, 500), size: Vector2(32.0, 64.0), speed: 60.0));
    add(Skeleton(
        position: Vector2(300, 500), size: Vector2(32.0, 64.0), speed: 60.0));
    add(ScreenHitbox());
    add(hud);
  }

  @override
  void onRemove() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();

    super.onRemove();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    switch (state) {
      case AppLifecycleState.paused:
        for (var component in children) {
          if (component is Character) {
            component.onPaused();
          }
        }
        break;
      case AppLifecycleState.resumed:
        for (var component in children) {
          if (component is Character) {
            component.onResumed();
          }
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }
}
