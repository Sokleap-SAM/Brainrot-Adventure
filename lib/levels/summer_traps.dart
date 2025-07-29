import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum TrapState { running, hit }

class SummerTraps extends SpriteAnimationGroupComponent
    with HasGameReference<BrainrotAdventure> {
  String summertraps;
  final double stepTime = 0.25;
  late final SpriteAnimation runningAnimation, hitAnimation; 
  double leftRange = 16 * 10;
  double rightRange = 16 * 10;
  double movement = -120; 
  RectangleHitbox trapHitBox = RectangleHitbox(
    position: Vector2(2, 2),
    size: Vector2(60, 60),
  );
  bool isFacingLeft = true;

  SummerTraps({super.position, super.size, this.summertraps = 'Saws'});

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    leftRange = position.x - leftRange + width / 2;
    rightRange = position.x + rightRange + width / 2;
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

  void _trapMovement(dt) {
    final positionX = isFacingLeft
        ? (position.x + trapHitBox.position.x)
        : (position.x - trapHitBox.position.x);
    if (positionX < leftRange) {
      isFacingLeft = false;
      flipHorizontallyAroundCenter();
      movement = 110;
    }
    if (positionX > rightRange) {
      isFacingLeft = true;
      flipHorizontallyAroundCenter();
      movement = -110;
    }

    position.x += movement * dt;
  }
}