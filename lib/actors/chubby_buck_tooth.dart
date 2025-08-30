import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class ChubbyBuckTooth extends SpriteAnimationComponent
    with HasGameReference<BrainrotAdventure>, CollisionCallbacks {
  double negativeRange;
  double positiveRange;
  double velocity;
  bool isFacingLeft = true;
  late final RectangleHitbox enemyHitBox;
  final String enemyName;

  ChubbyBuckTooth({
    super.position,
    super.size,
    required this.enemyName,
    required this.negativeRange,
    required this.positiveRange,
    required this.velocity,
  });

  @override
  FutureOr<void> onLoad() {
    setTileRange();
    _setEnemyHitBox();
    add(enemyHitBox);
    animation = _spriteAnimation("Running", 4, true);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _enemyMovement(dt);
    super.update(dt);
  }

  SpriteAnimation _spriteAnimation(
    String state,
    int spriteAmount,
    bool isLoop,
  ) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Enemy/$enemyName/$state.png"),
      SpriteAnimationData.sequenced(
        amount: spriteAmount,
        stepTime: (1.0 / spriteAmount),
        textureSize: size,
        loop: isLoop,
      ),
    );
  }

  void _setEnemyHitBox() {
    enemyHitBox = RectangleHitbox(
      position: Vector2(8, 34),
      size: Vector2(48, 30),
    );
  }

  void _enemyMovement(dt) {
    final positionX = isFacingLeft
        ? (position.x + enemyHitBox.position.x)
        : (position.x - enemyHitBox.position.x);
    if (positionX < negativeRange) {
      isFacingLeft = false;
      flipHorizontallyAroundCenter();
    } else if (positionX > positiveRange) {
      isFacingLeft = true;
      flipHorizontallyAroundCenter();
    }
    position.x += (isFacingLeft ? -velocity : velocity) * dt;
  }

  void setTileRange() {
    negativeRange = position.x - positiveRange + width / 2;
    positiveRange = position.x + positiveRange + width / 2;
  }
}
