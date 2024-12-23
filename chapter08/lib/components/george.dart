import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'hud/hud.dart';
import 'skeleton.dart';
import 'water.dart';
import 'zombie.dart';
import 'coin.dart';
import 'character.dart';
import '../utils/math_utils.dart';
import 'package:flame_audio/flame_audio.dart';

class George extends Character with KeyboardHandler {
  George(
      {required this.hud,
      required Vector2 position,
      required super.size,
      required super.speed})
      : super(position: position) {
    originalPosition = position;
  }

  final HudComponent hud;
  late double walkingSpeed, runningSpeed;
  late Vector2 targetLocation;
  bool movingToTouchedLocation = false;
  bool isMoving = false;
  late AudioPlayer audioPlayerRunning;
  int collisionDirection = Character.down;
  bool hasCollided = false;
  bool keyLeftPressed = false,
      keyRightPressed = false,
      keyUpPressed = false,
      keyDownPressed = false,
      keyRunningPressed = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    priority = 15;

    walkingSpeed = speed;
    runningSpeed = speed * 2;

    var spriteImages = await Flame.images.load('george.png');
    final spriteSheet =
        SpriteSheet(image: spriteImages, srcSize: Vector2(width, height));

    downAnimation =
        spriteSheet.createAnimationByColumn(column: 0, stepTime: 0.2);
    leftAnimation =
        spriteSheet.createAnimationByColumn(column: 1, stepTime: 0.2);
    upAnimation = spriteSheet.createAnimationByColumn(column: 2, stepTime: 0.2);
    rightAnimation =
        spriteSheet.createAnimationByColumn(column: 3, stepTime: 0.2);

    animation = downAnimation;
    playing = false;
    anchor = Anchor.center;

    add(RectangleHitbox.relative(Vector2(0.7, 0.7),
        parentSize: size, position: Vector2(10.0, 10.0)));

    await FlameAudio.audioCache.loadAll(
        ['sounds/enemy_dies.wav', 'sounds/running.wav', 'sounds/coin.wav']);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event.logicalKey.keyLabel.toLowerCase().contains('a')) {
      keyLeftPressed = (event is KeyDownEvent);
    }
    if (event.logicalKey.keyLabel.toLowerCase().contains('d')) {
      keyRightPressed = (event is KeyDownEvent);
    }
    if (event.logicalKey.keyLabel.toLowerCase().contains('w')) {
      keyUpPressed = (event is KeyDownEvent);
    }
    if (event.logicalKey.keyLabel.toLowerCase().contains('s')) {
      keyDownPressed = (event is KeyDownEvent);
    }
    if (event.logicalKey.keyLabel.toLowerCase().contains('r')) {
      keyRunningPressed = (event is KeyDownEvent);
    }

    return true;
  }

  void moveToLocation(Vector2 location) {
    targetLocation = location;
    movingToTouchedLocation = true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Zombie || other is Skeleton) {
      other.removeFromParent();
      hud.scoreText.setScore(10);

      FlameAudio.play('sounds/enemy_dies.wav', volume: 1.0);
    }

    if (other is Coin) {
      other.removeFromParent();
      hud.scoreText.setScore(20);

      FlameAudio.play('sounds/coin.wav', volume: 1.0);
    }

    if (other is Water) {
      if (!hasCollided) {
        if (movingToTouchedLocation) {
          movingToTouchedLocation = false;
        } else {
          hasCollided = true;
          collisionDirection = currentDirection;
        }
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    hasCollided = false;
  }

  @override
  void update(double dt) async {
    super.update(dt);

    speed = (hud.runButton.buttonPressed || keyRunningPressed)
        ? runningSpeed
        : walkingSpeed;
    final bool isMovingByKeys =
        keyLeftPressed || keyRightPressed || keyUpPressed || keyDownPressed;

    if (!hud.joystick.delta.isZero()) {
      movePlayer(dt);
      playing = true;
      movingToTouchedLocation = false;

      if (!isMoving) {
        isMoving = true;
        audioPlayerRunning =
            await FlameAudio.loopLongAudio('sounds/running.wav', volume: 1.0);
      }

      switch (hud.joystick.direction) {
        case JoystickDirection.up:
        case JoystickDirection.upRight:
        case JoystickDirection.upLeft:
          animation = upAnimation;
          currentDirection = Character.up;
          break;
        case JoystickDirection.down:
        case JoystickDirection.downRight:
        case JoystickDirection.downLeft:
          animation = downAnimation;
          currentDirection = Character.down;
          break;
        case JoystickDirection.left:
          animation = leftAnimation;
          currentDirection = Character.left;
          break;
        case JoystickDirection.right:
          animation = rightAnimation;
          currentDirection = Character.right;
          break;
        case JoystickDirection.idle:
          animation = null;
          break;
      }
    } else if (isMovingByKeys) {
      movePlayer(dt);
      playing = true;
      movingToTouchedLocation = false;

      if (!isMoving) {
        isMoving = true;
        audioPlayerRunning =
            await FlameAudio.loopLongAudio('sounds/running.wav', volume: 1.0);
      }

      if (keyUpPressed && (keyLeftPressed || keyRightPressed)) {
        animation = upAnimation;
        currentDirection = Character.up;
      } else if (keyDownPressed && (keyLeftPressed || keyRightPressed)) {
        animation = downAnimation;
        currentDirection = Character.down;
      } else if (keyLeftPressed) {
        animation = leftAnimation;
        currentDirection = Character.left;
      } else if (keyRightPressed) {
        animation = rightAnimation;
        currentDirection = Character.right;
      } else if (keyUpPressed) {
        animation = upAnimation;
        currentDirection = Character.up;
      } else if (keyDownPressed) {
        animation = downAnimation;
        currentDirection = Character.down;
      } else {
        animation = null;
      }
    } else {
      if (movingToTouchedLocation) {
        if (!isMoving) {
          isMoving = true;
          audioPlayerRunning =
              await FlameAudio.loopLongAudio('sounds/running.wav', volume: 1.0);
        }

        movePlayer(dt);
        double threshhold = 1.0;
        var difference = targetLocation - position;
        if (difference.x.abs() < threshhold &&
            difference.y.abs() < threshhold) {
          stopAnimations();

          audioPlayerRunning.stop();
          isMoving = false;

          movingToTouchedLocation = false;
          return;
        }

        playing = true;

        var angle = getAngle(position, targetLocation);
        if ((angle > 315 && angle < 360) || (angle > 0 && angle < 45)) {
          // Moving right
          animation = rightAnimation;
          currentDirection = Character.right;
        } else if (angle > 45 && angle < 135) {
          // Moving down
          animation = downAnimation;
          currentDirection = Character.down;
        } else if (angle > 135 && angle < 225) {
          // Moving left
          animation = leftAnimation;
          currentDirection = Character.left;
        } else if (angle > 225 && angle < 315) {
          // Moving up
          animation = upAnimation;
          currentDirection = Character.up;
        }
      } else {
        if (playing) {
          stopAnimations();
        }
        if (isMoving) {
          isMoving = false;
          audioPlayerRunning.stop();
        }
      }
    }
  }

  void movePlayer(double delta) {
    if (!(hasCollided && collisionDirection == currentDirection)) {
      if (movingToTouchedLocation) {
        position
            .add((targetLocation - position).normalized() * (speed * delta));
      } else {
        switch (currentDirection) {
          case Character.left:
            position.add(Vector2(delta * -speed, 0));
            break;
          case Character.right:
            position.add(Vector2(delta * speed, 0));
            break;
          case Character.up:
            position.add(Vector2(0, delta * -speed));
            break;
          case Character.down:
            position.add(Vector2(0, delta * speed));
            break;
        }
      }
    }
  }

  void stopAnimations() {
    animation?.createTicker().currentIndex = 0;
    playing = false;

    keyLeftPressed = false;
    keyRightPressed = false;
    keyUpPressed = false;
    keyDownPressed = false;
  }

  @override
  void onPaused() {
    if (isMoving) {
      audioPlayerRunning.pause();
    }
  }

  @override
  void onResumed() async {
    if (isMoving) {
      audioPlayerRunning.resume();
    }
  }
}
