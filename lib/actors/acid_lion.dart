import 'dart:async';
import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:brainrot_adventure/components/bullet.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

// No longer using a group of animations, so no need for this enum.
enum EnemyState { shooting, idling }

class AcidLion extends SpriteAnimationGroupComponent
    with HasGameReference<BrainrotAdventure>, CollisionCallbacks {
  bool isFacingLeft = true;
  late final RectangleHitbox enemyHitBox;
  late final Timer _fireTimer;
  final double _fireInterval = 1.5;
  late final SpriteAnimation _idlingAnimation, _shootingAnimation;
  final String enemyName;
  final double firingRangeInTiles;

  AcidLion({
    super.position,
    super.size,
    required this.enemyName,
    required this.firingRangeInTiles,
  });

  @override
  Future<void> onLoad() async {
    anchor = Anchor.topCenter;
    _setEnemyHitBox();
    add(enemyHitBox);
    _loadAnimation();

    _fireTimer = Timer(
      _fireInterval,
      onTick: _fire,
      repeat: true,
      autoStart: false,
    );

    super.onLoad();
  }

  @override
  void update(double dt) {
    _detectPlayer(dt);
    _fireTimer.update(dt);
    super.update(dt);
  }

  void _setEnemyHitBox() {
    enemyHitBox = RectangleHitbox(
      position: Vector2(68, 56),
      size: Vector2(90, 72),
      anchor: Anchor.topLeft,
    );
  }

  void _loadAnimation() {
    _idlingAnimation = _spriteAnimation('Idling', 2, true);
    _shootingAnimation = _spriteAnimation('Shooting', 4, false);

    animations = {
      EnemyState.idling: _idlingAnimation,
      EnemyState.shooting: _shootingAnimation,
    };

    current = EnemyState.idling;
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

  void _detectPlayer(dt) {
    final player = game.player;

    final double playerDistance = (player.x - position.x).abs();
    final double firingRangeInPixels = firingRangeInTiles * 16;

    if (playerDistance <= firingRangeInPixels) {
      if (!_fireTimer.isRunning()) {
        _fireTimer.start();
      }
    } else {
      _fireTimer.stop();
    }

    if (player.x < position.x) {
      if (!isFacingLeft) {
        isFacingLeft = true;
        flipHorizontallyAroundCenter();
      }
    } else {
      if (isFacingLeft) {
        isFacingLeft = false;
        flipHorizontallyAroundCenter();
      }
    }
  }

  void _fire() {
    Future.delayed(Duration(milliseconds: 1000), () {
      // Ensure the component is still in the game before proceeding
      if (isMounted && !isRemoved) {
        // Create and add the bullet after the animation has completed
        final double bulletTravelDistance = firingRangeInTiles * 16;
        Vector2 basePosition = Vector2(position.x, position.y + size.y * 0.5);
        Vector2 bulletPosition = basePosition;
        bulletPosition.x += isFacingLeft ? -40 : 40;

        final bullet = Bullet(
          position: bulletPosition,
          direction: isFacingLeft ? Vector2(-1, 0) : Vector2(1, 0),
          speed: 100,
          bulletName: 'Acid',
          bulletHitbox: RectangleHitbox(
            position: Vector2(10, 13),
            size: Vector2(44, 38),
          ),
          spriteAmount: 2,
          travelDistance: bulletTravelDistance,
        );
        parent?.add(bullet);

        // Switch back to idling animation
        current = EnemyState.idling;
      }
    });
  }
}
