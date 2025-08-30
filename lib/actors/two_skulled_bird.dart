import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum EnemyState { flying, hit }

class TwoSkulledBird extends SpriteAnimationComponent
    with HasGameReference<BrainrotAdventure>, CollisionCallbacks {
  double negativeRange;
  double positiveRange;
  double velocity;
  bool isFacingLeft = true;
  late final RectangleHitbox enemyHitBox;
  final String enemyName;

  TwoSkulledBird({
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
    animation = animation = _spriteAnimation("Flying", 5, true);
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
      position: Vector2(8, 9),
      size: Vector2(50, 28),
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
