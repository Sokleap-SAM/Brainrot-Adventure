import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:brainrot_adventure/components/bullet.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum EnemyState { flying, dropping }

class NuclearEagle extends SpriteAnimationComponent
    with HasGameReference<BrainrotAdventure>, CollisionCallbacks {
  double negativeRange;
  double positiveRange;
  double velocity;
  bool isFacingLeft = true;
  late final RectangleHitbox enemyHitBox;
  late final Timer _fireTimer;
  final double _fireInterval = 1.5;
  final double firingRangeInTiles;
  final String enemyName;

  NuclearEagle({
    super.position,
    super.size,
    required this.enemyName,
    required this.negativeRange,
    required this.positiveRange,
    required this.velocity,
    required this.firingRangeInTiles,
  });

  @override
  FutureOr<void> onLoad() {
    setTileRange();
    _setEnemyHitBox();
    add(enemyHitBox);
    animation = _spriteAnimation("Flying", 2, true);
    _fireTimer = Timer(
      _fireInterval,
      onTick: _fire,
      repeat: true,
      autoStart: true,
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _enemyMovement(dt);
    _fireTimer.update(dt);
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
      position: Vector2(30, 26),
      size: Vector2(68, 69),
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

  void _fire() {
    final tempVelocity = velocity;
    velocity = 0;
    final double bulletTravelDistance = firingRangeInTiles * 16;

    Vector2 basePosition = Vector2(position.x, position.y + size.y / 2);

    Vector2 bulletPosition = basePosition;
    bulletPosition.x += isFacingLeft ? 0 : -40;

    final bullet = Bullet(
      position: bulletPosition,
      direction: Vector2(0, 1),
      spriteAmount: 2,
      bulletName: 'Poison',
      bulletHitbox: RectangleHitbox(
        position: Vector2(20, 18),
        size: Vector2(24, 28),
      ),
      speed: 200,
      travelDistance: bulletTravelDistance,
    );
    parent?.add(bullet);
    velocity = tempVelocity;
  }
}
