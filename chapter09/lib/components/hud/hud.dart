import 'package:flame/components.dart';
import 'run_button.dart';
import 'score_text.dart';
import 'joystick.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import '../../utils/math_utils.dart';

class HudComponent extends PositionComponent {
  HudComponent() : super(priority: 20);

  late Joystick joystick;
  late RunButton runButton;
  late ScoreText scoreText;
  bool isInitialised = false;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    Rect gameScreenBounds = getGameScreenBounds(size);

    if (!isInitialised) {
      final joystickKnobPaint = BasicPalette.blue.withAlpha(200).paint();
      final joystickBackgroundPaint = BasicPalette.blue.withAlpha(100).paint();
      final buttonRunPaint = BasicPalette.red.withAlpha(200).paint();
      final buttonDownRunPaint = BasicPalette.red.withAlpha(100).paint();

      joystick = Joystick(
        knob: CircleComponent(radius: 20.0, paint: joystickKnobPaint),
        background:
            CircleComponent(radius: 40.0, paint: joystickBackgroundPaint),
        position:
            Vector2(gameScreenBounds.left + 100, gameScreenBounds.bottom - 80),
      );

      runButton = RunButton(
          button: CircleComponent(radius: 25.0, paint: buttonRunPaint),
          buttonDown: CircleComponent(radius: 25.0, paint: buttonDownRunPaint),
          position: Vector2(
              gameScreenBounds.right - 80, gameScreenBounds.bottom - 80),
          onPressed: () => {});

      scoreText = ScoreText(
          position:
              Vector2(gameScreenBounds.left + 80, gameScreenBounds.top + 60));

      add(joystick);
      add(runButton);
      add(scoreText);

      isInitialised = true;
    } else {
      joystick.position =
          Vector2(gameScreenBounds.left + 80, gameScreenBounds.bottom - 80);
      runButton.position =
          Vector2(gameScreenBounds.right - 80, gameScreenBounds.bottom - 80);
      scoreText.position =
          Vector2(gameScreenBounds.left + 80, gameScreenBounds.top + 60);
    }
  }
}
