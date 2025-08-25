import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:brainrot_adventure/components/summer_objects.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Chest extends SpriteAnimationComponent
    with HasGameReference<BrainrotAdventure>, CollisionCallbacks {
  final String objectName;
  bool isOpen = false;
  bool isEmpty;
  int spriteAmount;

  Chest({
    super.position,
    super.size,
    this.objectName = 'BeachBall',
    this.spriteAmount = 1,
    this.isEmpty = false,
  });

  final double stepTime = 0.40;
  RectangleHitbox objectHitBox = RectangleHitbox(
    position: Vector2(14, 10),
    size: Vector2(30, 44),
    anchor: Anchor.topLeft,
    collisionType: CollisionType.passive,
  );

  @override
  FutureOr<void> onLoad() {
    add(objectHitBox);
    // debugMode = true;
    priority = -1;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Chest/chest-idle.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.5,
        textureSize: size,
      ),
    );
    return super.onLoad();
  }

  void chestCollideWithPlayer() async {
    if (!isOpen) {
      isOpen = true;
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Chest/chest-open.png'),
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.20,
          textureSize: size,
          loop: false,
        ),
      );
      animationTicker?.onComplete = () {
        if (!isEmpty) {
          final object = SummerObjects(
            summerobject: objectName,
            size: size,
            position: Vector2(position.x, position.y - 60.0),
            spriteAmount: spriteAmount,
          );
          parent?.add(object);
        }
        removeFromParent();
      };
    }
  }
}
