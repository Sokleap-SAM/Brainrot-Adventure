import 'dart:async';

import 'package:brainrot_adventure/levels/collision_block.dart';
import 'package:brainrot_adventure/test_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, running, jumping, falling, crouch }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<BrainrotAdventure>, KeyboardHandler, CollisionCallbacks {
  String character;
  Player({position, this.character = "Wizard_Ducky"})
    : super(position: position);

  late final SpriteAnimation idleAnimation,
      runningAnimation,
      jumpingAnimation,
      fallingAnimation;
  final double stepTime = 0.25;

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 150.0;
  Vector2 velocity = Vector2.zero();
  bool isFacingLeft = false;

  bool isJumping = false;
  final double gravity = 9.8;
  final double jumpForce = -400.0;
  final double terminalVelocity = 300;

  bool isOnGround = false;
  bool isCrouch = false;
  // List<CollisionBlock> collisionBlocks = [];
  // RectangleHitbox playerHitBox = RectangleHitbox(
  //   position: Vector2(10, 6),
  //   size: Vector2(44, 58),
  //   anchor: Anchor.topLeft,
  // );

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    add(
      RectangleHitbox(
        size: Vector2(38, 58), // Width, Height - should be smaller than sprite
        anchor: Anchor.bottomCenter, // Center the hitbox
        position: Vector2(width / 2, height), // Center position
      )..debugMode = true,
    );
    // add(playerHitBox);
    debugMode = true;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    // _checkHorizontalCollisions();
    _applyGravity(dt);
    if (!isOnGround) {
      current = velocity.y > 0 ? PlayerState.falling : PlayerState.jumping;
    } else {
      current = velocity.x != 0 ? PlayerState.running : PlayerState.idle;
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _updateHorizontalDirection(keysPressed);
    _handleJumpInput(keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }

  void _updateHorizontalDirection(Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }
  }

  void _handleJumpInput(Set<LogicalKeyboardKey> keysPressed) {
    final isJumpKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);

    if (isJumpKeyPressed && !isJumping && isOnGround) {
      // Added isOnGround check
      isJumping = true;
      isOnGround = false;
      velocity.y = jumpForce;
    }
  }

  void _loadAllAnimation() {
    idleAnimation = _spriteAnimation('idle', 5);
    runningAnimation = _spriteAnimation('run', 4);
    jumpingAnimation = _spriteAnimation('jump', 1);
    fallingAnimation = _spriteAnimation('fall', 1);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
    };
    flipHorizontallyAroundCenter();
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amountFrame) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Player/$character/$state.png"),
      SpriteAnimationData.sequenced(
        amount: amountFrame,
        stepTime: stepTime,
        textureSize: Vector2.all(64),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = _getHorizontalVelocity();
    _updateFacingDirection();
    position.x += velocity.x * dt;
  }

  double _getHorizontalVelocity() {
    switch (playerDirection) {
      case PlayerDirection.left:
        return -moveSpeed;
      case PlayerDirection.right:
        return moveSpeed;
      case PlayerDirection.none:
        return 0.0;
    }
  }

  void _updateFacingDirection() {
    if (playerDirection == PlayerDirection.left && !isFacingLeft) {
      flipHorizontallyAroundCenter();
      isFacingLeft = true;
    } else if (playerDirection == PlayerDirection.right && isFacingLeft) {
      flipHorizontallyAroundCenter();
      isFacingLeft = false;
    }
  }

  void _applyGravity(double dt) {
    velocity.y += gravity; // Always apply gravity
    velocity.y = velocity.y.clamp(jumpForce, terminalVelocity);
    position.y += velocity.y * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is CollisionBlock) {
      _resolveCollision(other);
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // Logic for when a collision ends
    super.onCollisionEnd(other);
  }

  // bool _collided(CollisionBlock block) {
  //   return (position.y < block.y + block.height &&
  //       position.y + height > block.y &&
  //       position.x < block.x + block.width &&
  //       position.x + width > block.x);
  // }

  void _resolveCollision(CollisionBlock block) {
    final playerRect = toAbsoluteRect();
    final blockRect = block.toAbsoluteRect();

    final double overlapX =
        (playerRect.width + blockRect.width) / 2 -
        (playerRect.center.dx - blockRect.center.dx).abs();
    final double overlapY =
        (playerRect.height + blockRect.height) / 2 -
        (playerRect.center.dy - blockRect.center.dy).abs();

    // Determine which side we're colliding from
    if (overlapX < overlapY) {
      if (block.isPlatform) {
      } else {
        // Horizontal collision
        if (playerRect.center.dx < blockRect.center.dx) {
          // Colliding from left

          position.x = blockRect.left + 12;
        } else {
          // Colliding from right
          position.x = blockRect.right - 12;
        }
        velocity.x = 0; // Stop horizontal movement
      }
    } else {
      // Vertical collision
      if (playerRect.center.dy < blockRect.center.dy && overlapX != 0) {
        // Colliding from above (landing)
        position.y = blockRect.top - playerRect.height;
        velocity.y = 0;
        isOnGround = true;
        isJumping = false;
      } else if (!block.isPlatform) {
        // Colliding from below (hitting head) - only for solid blocks
        position.y = blockRect.bottom;
        velocity.y = 0;
      }
    }
    // print("After: $overlapY | $overlapX");
  }

  // void _checkHorizontalCollisions() {
  //   for (final block in collisionBlocks) {
  //     if (!block.isPlatform) {
  //       if (checkCollision(this, block)) {
  //         print(velocity.x);
  //         if (velocity.x > 0) {
  //           velocity.x = 0;
  //           position.x = block.x + 9;
  //           // print(
  //           //   "player: $position\n,playerBox: ${playerHitBox.position}\n,block: ${block.position}\n",
  //           // );
  //         }
  //         if (velocity.x < 0) {
  //           velocity.x = 0;
  //           position.x = block.x + block.width - playerHitBox.position.x;
  //         }
  //       } else {}
  //     }
  //   }
  // }

  // // Replace your entire _checkVerticalCollisions with this improved version
  // void _checkVerticalCollisions() {
  //   bool wasOnGround = isOnGround;
  //   isOnGround = false;

  //   for (final block in collisionBlocks) {
  //     if (block.isPlatform) {
  //     } else {
  //       if (CollisionSystem.checkCollision(this, block)) {
  //         if (velocity.y > 0) {
  //           velocity.y = 0;
  //           position.y = block.y - width;
  //           isOnGround = true;
  //         }
  //         if (velocity.y < 0) {
  //           velocity.y = 0;
  //           position.y = block.y + block.height;
  //         }
  //       }
  //     }
  //   }
  // }
}
