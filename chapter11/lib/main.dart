import 'package:flame/experimental.dart'; // Shape / Rectangle.fromLTRB
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'dart:math';
import 'package:goldrush/components/background.dart';
import 'package:goldrush/components/character.dart';
import 'package:goldrush/components/coin.dart';
import 'package:goldrush/components/george.dart';
import 'package:goldrush/components/hud/hud.dart';
import 'package:goldrush/components/water.dart';
import 'package:goldrush/components/zombie.dart';
import 'package:goldrush/components/skeleton.dart';
import 'package:goldrush/utils/map_utils.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:goldrush/components/tilemap.dart';
import 'package:goldrush/utils/math_utils.dart';
import 'package:goldrush/widgets/screen_gameover.dart';
import 'package:goldrush/widgets/screen_menu.dart';
import 'package:goldrush/widgets/screen_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gold Rush',
      initialRoute: '/',
      routes: {
        '/': (context) => MenuScreen(),
        '/settings': (context) => SettingsScreen(),
        '/gameover': (context) => GameOverScreen(),
        '/game': (context) => GameWidget(game: GoldRush()),
      },
    ),
  );
}

class GoldRush extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    Rect gameScreenBounds = getGameScreenBounds(canvasSize);

    late double musicVolume;
    await SharedPreferences.getInstance()
        .then((prefs) => prefs.getDouble('musicVolume') ?? 25.0)
        .then((savedMusicVolume) => musicVolume = savedMusicVolume);

    FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play('music/music.mp3', volume: (musicVolume / 100));

    final tiledMap = await TiledComponent.load('tiles.tmx', Vector2.all(32));
    world.add(TileMapComponent(tiledMap));

    List<(int, int)> barrierOffsets = [];
    final water = tiledMap.tileMap.getLayer<ObjectGroup>('Water');
    water?.objects.forEach((rect) {
      if (rect.width == 32 && rect.height == 32) {
        barrierOffsets.add(worldToGridIntTuple(Vector2(rect.x, rect.y)));
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
        var skeleton = Skeleton(
            player: george,
            position: Vector2(position.x + gameScreenBounds.left,
                position.y + gameScreenBounds.top),
            size: Vector2(32.0, 64.0),
            speed: 20.0);
        world.add(skeleton);
      } else {
        var zombie = Zombie(
            player: george,
            position: Vector2(position.x + gameScreenBounds.left,
                position.y + gameScreenBounds.top),
            size: Vector2(32.0, 64.0),
            speed: 20.0);
        world.add(zombie);
      }
    });

    Random random = Random(DateTime.now().millisecondsSinceEpoch);
    for (int i = 0; i < 50; i++) {
      int randomX = random.nextInt(48) + 1;
      int randomY = random.nextInt(48) + 1;
      double posCoinX = (randomX * 32) + 5 + gameScreenBounds.left;
      double posCoinY = (randomY * 32) + 5 + gameScreenBounds.top;

      var coin =
          Coin(position: Vector2(posCoinX, posCoinY), size: Vector2(20, 20));
      world.add(coin);
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
