import 'package:flame/experimental.dart'; // Shape / Rectangle.fromLTRB

import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'dart:math';
import 'components/background.dart';
import 'components/character.dart';
import 'components/coin.dart';
import 'components/george.dart';
import 'components/hud/hud.dart';
import 'components/water.dart';
import 'components/zombie.dart';
import 'components/skeleton.dart';
import 'utils/map_utils.dart';
import 'package:flame_audio/flame_audio.dart';
import 'components/tilemap.dart';
import 'utils/math_utils.dart';

void main() async {
  final goldRush = GoldRush();

  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(GameWidget(game: goldRush));
}

class GoldRush extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late NotifyingVector2 mapSize;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    Rect gameScreenBounds = getGameScreenBounds(canvasSize);

    FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play('music/music.mp3', volume: 0.5);

    final tiledMap = await TiledComponent.load('tiles.tmx', Vector2.all(32));
    mapSize = tiledMap.size;
    world.add(TileMapComponent(tiledMap));

    List<Offset> barrierOffsets = [];
    final water = tiledMap.tileMap.getLayer<ObjectGroup>('Water');
    water?.objects.forEach((rect) {
      if (rect.width == 32 && rect.height == 32) {
        barrierOffsets.add(worldToGridOffset(Vector2(rect.x, rect.y)));
      }
      world.add(Water(
          position: Vector2(
              rect.x + gameScreenBounds.left, rect.y + gameScreenBounds.top),
          size: Vector2(rect.width, rect.height),
          id: rect.id));
    });

    var hud = HudComponent();
    var george = George(
        barrierOffsets: barrierOffsets,
        hud: hud,
        position:
            Vector2(gameScreenBounds.left + 300, gameScreenBounds.top + 300),
        size: Vector2(32.0, 32.0),
        speed: 40.0);
    world.add(george);

    world.add(Background(george));

    final enemies = tiledMap.tileMap.getLayer<ObjectGroup>('Enemies');
    enemies?.objects.asMap().forEach((index, position) {
      if (index % 2 == 0) {
        world.add(Skeleton(
            player: george,
            position: Vector2(position.x + gameScreenBounds.left,
                position.y + gameScreenBounds.top),
            size: Vector2(32.0, 64.0),
            speed: 20.0));
      } else {
        world.add(Zombie(
            player: george,
            position: Vector2(position.x + gameScreenBounds.left,
                position.y + gameScreenBounds.top),
            size: Vector2(32.0, 64.0),
            speed: 20.0));
      }
    });

    Random random = Random(DateTime.now().millisecondsSinceEpoch);
    for (int i = 0; i < 50; i++) {
      int randomX = random.nextInt(48) + 1;
      int randomY = random.nextInt(48) + 1;
      double posCoinX = (randomX * 32) + 5 + gameScreenBounds.left;
      double posCoinY = (randomY * 32) + 5 + gameScreenBounds.top;

      world.add(
          Coin(position: Vector2(posCoinX, posCoinY), size: Vector2(20, 20)));
    }

    camera.follow(george);
    Rectangle rect = Rectangle.fromLTRB(
        size.x / 2, size.y / 2, 1600 - size.x / 2, 1600 - size.y / 2);
    camera.setBounds(rect);
    camera.viewport.add(hud);
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
