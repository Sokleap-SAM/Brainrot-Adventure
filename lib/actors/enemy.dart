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
  double negativeRange;
  double positiveRange;
  bool isVerticalMovement;
  late double setVelocity;
  double velocity;
  double movement = -100;
  RectangleHitbox enemyHitBox = RectangleHitbox(
    position: Vector2(8, 34),
    size: Vector2(48, 30),
  );
  bool isFacingLeft = true;

  Enemy({
    super.position,
    super.size,
    this.enemyName = 'Chubby Buck Tooth',
    required this.negativeRange,
    required this.positiveRange,
    required this.isVerticalMovement,
    required this.velocity,
  });

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    setTileRange();
    add(enemyHitBox);
    _loadAnimation();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _enemyMovement(dt);
    super.update(dt);
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
    if (isVerticalMovement) {
      _enemyVerticalMovement(dt);
      return;
    }
    _enemyHorizonstalMovement(dt);
  }

  void _enemyHorizonstalMovement(dt) {
    final positionX = isFacingLeft
        ? (position.x + enemyHitBox.position.x)
        : (position.x - enemyHitBox.position.x);
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

  void _enemyVerticalMovement(dt) {
    final positionY = isFacingLeft
        ? (position.y + enemyHitBox.position.y)
        : (position.y - enemyHitBox.position.y);
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
