import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameReference, CollisionCallbacks {
  final double speed;
  final Vector2 direction;
  final double travelDistance;
  final String bulletName;
  final int spriteAmount;
  final RectangleHitbox bulletHitbox;

  late final Vector2 _startPosition;

  Bullet({
    super.position,
    required this.direction,
    required this.speed,
    required this.travelDistance,
    required this.bulletName,
    required this.spriteAmount,
    required this.bulletHitbox,
  }) : super(size: Vector2(64, 64));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _startPosition = position.clone();
    debugMode = true;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Projectile/$bulletName/Projectiling.png'),
      SpriteAnimationData.sequenced(
        amount: spriteAmount,
        stepTime: (1.0 / spriteAmount),
        textureSize: size,
      ),
    );
    add(bulletHitbox);
  }

  @override
  void update(double dt) {
    position += (direction * speed * dt);

    final distanceTraveled = _startPosition.distanceTo(position);

    if (distanceTraveled >= travelDistance) {
      removeFromParent();
      return;
    }

    if (position.x < 0 ||
        position.x > 2560 ||
        position.y < 0 ||
        position.y > 1440) {
      removeFromParent();
    }

    super.update(dt);
  }

  void bulletCollideWithPlayer() async {
    removeFromParent();
  }
}
