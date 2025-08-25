import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum TrapState { running, hit }

class SummerTraps extends SpriteAnimationGroupComponent
    with HasGameReference<BrainrotAdventure> {
  String summertraps;
  bool isVerticalMovement;
  final double stepTime = 0.25;
  late final SpriteAnimation runningAnimation, hitAnimation;
  double negativeRange;
  double positiveRange;
  late double setVelocity;
  double velocity;
  RectangleHitbox trapHitBox = RectangleHitbox(
    position: Vector2(2, 2),
    size: Vector2(60, 60),
  );
  bool isFacingLeft = true;

  SummerTraps({
    super.position,
    super.size,
    this.summertraps = 'Saws',
    required this.isVerticalMovement,
    required this.negativeRange,
    required this.positiveRange,
    required this.velocity,
  });

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    setTileRange();
    setVelocity = -velocity;
    add(trapHitBox);
    priority = -1;
    _loadAnimation();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _trapMovement(dt);
    super.update(dt);
  }

  void _loadAnimation() {
    runningAnimation = _spriteAnimation(4);
    // hitAnimation = _spriteAnimation('hit', 4)..loop = false;

    animations = {
      TrapState.running: runningAnimation,
      // TrapState.hit: hitAnimation,
    };

    current = TrapState.running;
  }

  SpriteAnimation _spriteAnimation(int amountFrame) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Traps/SummerTraps/$summertraps.png"),
      SpriteAnimationData.sequenced(
        amount: amountFrame,
        stepTime: stepTime,
        textureSize: Vector2.all(64),
      ),
    );
  }

  void setTileRange() {
    if (isVerticalMovement) {
      negativeRange = position.y - negativeRange + height / 2;
      positiveRange = position.y + positiveRange + height / 2;
      return;
    }
    negativeRange = position.x - positiveRange + width / 2;
    positiveRange = position.x + positiveRange + width / 2;
  }

  void _trapMovement(dt) {
    if (isVerticalMovement) {
      _trapVerticalMovement(dt);
      return;
    }
    _trapHorizonstalMovement(dt);
  }

  void _trapHorizonstalMovement(dt) {
    final positionX = isFacingLeft
        ? (position.x + trapHitBox.position.x)
        : (position.x - trapHitBox.position.x);
    if (positionX < negativeRange) {
      isFacingLeft = false;
      flipHorizontallyAroundCenter();
      setVelocity = velocity;
    }
    if (positionX > positiveRange) {
      isFacingLeft = true;
      flipHorizontallyAroundCenter();
      setVelocity = -velocity;
    }
    position.x += setVelocity * dt;
  }

  void _trapVerticalMovement(dt) {
    final positionY = isFacingLeft
        ? (position.y + trapHitBox.position.y)
        : (position.y - trapHitBox.position.y);
    if (positionY < negativeRange) {
      isFacingLeft = false;
      flipVerticallyAroundCenter();
      setVelocity = velocity;
    }
    if (positionY > positiveRange) {
      isFacingLeft = true;
      flipVerticallyAroundCenter();
      setVelocity = -velocity;
    }
    position.y += setVelocity * dt;
  }
}
