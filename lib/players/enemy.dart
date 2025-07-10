import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:brainrot_adventure/players/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum EnemyState { running, hit }

enum EnemyDirection { left, right }

class Enemy extends SpriteAnimationGroupComponent
    with HasGameReference<BrainrotAdventure> {
  String character;
  final double stepTime = 0.05;
  late final SpriteAnimation runningAnimation, hitAnimation;
  double leftRange = 16 * 10;
  double rightRange = 16 * 10;
  final double movement = 100;
  final player = Player();
  RectangleHitbox enemyHitBox = RectangleHitbox(
    position: Vector2(20, 20),
    size: Vector2(20, 20),
  );
  bool isFacingLeft = true;

  Enemy({super.position, super.size, this.character = 'MoMi Nori'});

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    leftRange = position.x - leftRange;
    _loadAnimation();
    return super.onLoad();
  }

  void _loadAnimation() {
    runningAnimation = _spriteAnimation('run', 4);
    hitAnimation = _spriteAnimation('hit', 4)..loop = false;

    animations = {
      EnemyState.running: runningAnimation,
      EnemyState.hit: hitAnimation,
    };

    current = EnemyState.running;
  }

  SpriteAnimation _spriteAnimation(String state, int amountFrame) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Enemy/$character/$state.png"),
      SpriteAnimationData.sequenced(
        amount: amountFrame,
        stepTime: stepTime,
        textureSize: Vector2.all(64),
      ),
    );
  }

  void horziontalMovement() {
    final positionX = isFacingLeft
        ? (position.x + enemyHitBox.position.x)
        : (position.x - enemyHitBox.position.x);
    if (positionX < leftRange) {
      isFacingLeft = false;
      flipHorizontallyAroundCenter();
    }
    if (positionX > rightRange) {
      isFacingLeft = true;
      flipHorizontallyAroundCenter();
    }
  }

  void collidedWithPlayer() {}
}
