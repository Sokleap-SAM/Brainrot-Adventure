import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class FinishFlag extends SpriteAnimationComponent
    with HasGameReference<BrainrotAdventure>, CollisionCallbacks {
  final String name;
  int spriteAmount;

  FinishFlag({
    super.position,
    super.size,
    this.name = 'sand_flag',
    this.spriteAmount = 1,
  });

  final double stepTime = 0.40;
  RectangleHitbox objectHitBox = RectangleHitbox(
    position: Vector2(14, 12),
    size: Vector2(36, 40),
    anchor: Anchor.topLeft,
    collisionType: CollisionType.passive,
  );

  @override
  FutureOr<void> onLoad() {
    add(objectHitBox);
    // debugMode = true;
    priority = -1;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/SummerObjects/$name.png'),
      SpriteAnimationData.sequenced(
        amount: spriteAmount,
        stepTime: stepTime,
        textureSize: size,
      ),
    );
    return super.onLoad();
  }

  void flagCollideWithPlayer() async {
    game.checkVictory();
  }
}
