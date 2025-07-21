import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum EnemyState { running, hit }

enum EnemyDirection { left, right }

class Enemy extends SpriteAnimationGroupComponent
    with HasGameReference<BrainrotAdventure> {
  String enemyName;
  final double stepTime = 0.25;
  late final SpriteAnimation runningAnimation, hitAnimation;
  double leftRange = 16 * 10;
  double rightRange = 16 * 10;
  double movement = -100;
  RectangleHitbox enemyHitBox = RectangleHitbox(
    position: Vector2(8, 34),
    size: Vector2(48, 30),
  );
  bool isFacingLeft = true;

  Enemy({super.position, super.size, this.enemyName = 'Chubby Buck Tooth'});

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    leftRange = position.x - leftRange + width / 2;
    rightRange = position.x + rightRange + width / 2;
    add(enemyHitBox);
    _loadAnimation();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _enemyMovement(dt);
    super.update(dt);
  }

  void _loadAnimation() {
    runningAnimation = _spriteAnimation('run', 4);
    // hitAnimation = _spriteAnimation('hit', 4)..loop = false;

    animations = {
      EnemyState.running: runningAnimation,
      // EnemyState.hit: hitAnimation,
    };

    current = EnemyState.running;
  }

  SpriteAnimation _spriteAnimation(String state, int amountFrame) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Enemy/$enemyName/$state.png"),
      SpriteAnimationData.sequenced(
        amount: amountFrame,
        stepTime: stepTime,
        textureSize: Vector2.all(64),
      ),
    );
  }

  void _enemyMovement(dt) {
    final positionX = isFacingLeft
        ? (position.x + enemyHitBox.position.x)
        : (position.x - enemyHitBox.position.x);
    if (positionX < leftRange) {
      isFacingLeft = false;
      flipHorizontallyAroundCenter();
      movement = 100;
    }
    if (positionX > rightRange) {
      isFacingLeft = true;
      flipHorizontallyAroundCenter();
      movement = -100;
    }

    position.x += movement * dt;
  }
}
