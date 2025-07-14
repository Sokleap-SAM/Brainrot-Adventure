import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Portal extends SpriteAnimationComponent
    with HasGameReference<BrainrotAdventure>, CollisionCallbacks {
  String name;

  Portal({super.position, super.size, this.name = "BeachBall"});

  final double stepTime = 0.40;
  RectangleHitbox portalHitBox = RectangleHitbox(
    position: Vector2(14, 12),
    size: Vector2(36, 40),
    anchor: Anchor.topLeft,
    collisionType: CollisionType.passive,
  );

  @override
  FutureOr<void> onLoad() {
    add(portalHitBox);
    debugMode = true;
    priority = -1;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/SummerObjects/BeachBall.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: stepTime,
        textureSize: size,
      ),
    );
    return super.onLoad();
  }
}
