import 'package:flame/experimental.dart'; // Shape / Rectangle.fromLTRB

import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:goldrush/components/character.dart';
import 'package:goldrush/components/hud/hud.dart';
import 'package:goldrush/components/water.dart';
import 'package:goldrush/components/zombie.dart';
import 'package:goldrush/components/skeleton.dart';
import 'components/background.dart';
import 'components/coin.dart';
import 'components/george.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dart:math';
import 'package:goldrush/components/tilemap.dart';
import 'package:goldrush/utils/math_utils.dart';

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
    await FlameAudio.bgm.play('music/music.mp3', volume: 0.05);

    var hud = HudComponent();
    var george = George(
        hud: hud,
        position:
            Vector2(gameScreenBounds.left + 300, gameScreenBounds.top + 300),
        size: Vector2(48.0, 48.0),
        speed: 40.0);
    world.add(george);

    world.add(Background(george));

    final tiledMap = await TiledComponent.load('tiles.tmx', Vector2.all(32));
    mapSize = tiledMap.size;
    world.add(TileMapComponent(tiledMap));

    final enemies = tiledMap.tileMap.getLayer<ObjectGroup>('Enemies');
    enemies?.objects.asMap().forEach((index, position) {
      if (index % 2 == 0) {
        world.add(Skeleton(
            position: Vector2(position.x + gameScreenBounds.left,
                position.y + gameScreenBounds.top),
            size: Vector2(32.0, 64.0),
            speed: 60.0));
      } else {
        world.add(Zombie(
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

    final water = tiledMap.tileMap.getLayer<ObjectGroup>('Water');
    water?.objects.forEach((rect) {
      world.add(Water(
          position: Vector2(
              rect.x + gameScreenBounds.left, rect.y + gameScreenBounds.top),
          size: Vector2(rect.width, rect.height),
          id: rect.id));
    });

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
        children.forEach((component) {
          if (component is Character) {
            component.onPaused();
          }
        });
        break;
      case AppLifecycleState.resumed:
        children.forEach((component) {
          if (component is Character) {
            component.onResumed();
          }
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }
}
