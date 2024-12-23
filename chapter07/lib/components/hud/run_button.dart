import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';

class RunButton extends HudButtonComponent {
  // ignore: use_super_parameters
  RunButton({
    required PositionComponent super.button,
    super.buttonDown,
    super.margin,
    super.position,
    Vector2? size,
    Anchor super.anchor = Anchor.center,
    void Function()? super.onPressed,
  }) : super(size: size ?? button.size);

  bool buttonPressed = false;

  @override
  bool onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    buttonPressed = true;

    return true;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    super.onTapUp(event);

    buttonPressed = false;

    return false;
  }

  @override
  bool onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);

    buttonPressed = false;

    return true;
  }
}
