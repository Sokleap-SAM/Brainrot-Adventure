import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class SummerObjects extends SpriteAnimationComponent with HasGameReference<BrainrotAdventure>, CollisionCallbacks {
  final String summerobject; 
  bool isCollected = false;

  SummerObjects({super.position, super.size, this.summerobject = 'BeachBall'}); 

  final double stepTime = 0.40;
  RectangleHitbox objectHitBox = RectangleHitbox( 
    position: Vector2(14, 12), 
    size: Vector2(36, 40), 
    anchor: Anchor.topLeft,
    collisionType: CollisionType.passive
  );

  @override
  FutureOr<void> onLoad() {
    add(objectHitBox);
    debugMode = true;
    priority = -1;
    animation = SpriteAnimation.fromFrameData(game.images.fromCache('Items/SummerObjects/$summerobject.png'), SpriteAnimationData.sequenced( 
      amount: 4, 
      stepTime: stepTime,
      textureSize: size, 
    ));
    return super.onLoad(); 
  }

  void collideWithPlayer() {
    if (!isCollected) {
      isCollected = true;
      removeFromParent(); 
    }
  }
}

