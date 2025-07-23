import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Portal extends SpriteAnimationComponent
    with HasGameReference<BrainrotAdventure>, CollisionCallbacks {
  String name;
  bool isStartingPortal;

  Portal({
    super.position,
    super.size,
    this.name = "BeachBall",
    this.isStartingPortal = false,
  });

  bool getPortalType() {
    return isStartingPortal;
  }

  final double stepTime = 0.40;
  RectangleHitbox portalHitBox = RectangleHitbox(
    position: Vector2(16, 20),
    size: Vector2(32, 44),
    anchor: Anchor.topLeft,
    collisionType: CollisionType.passive,
  );

  @override
  FutureOr<void> onLoad() {
    add(portalHitBox);
    // debugMode = true;
    priority = -1;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/SummerObjects/portal.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: stepTime,
        textureSize: size,
      ),
    );
    return super.onLoad();
  }
}
