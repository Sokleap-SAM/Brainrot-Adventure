import 'dart:async';

import 'package:brainrot_adventure/actors/acid_lion.dart';
import 'package:brainrot_adventure/actors/chubby_buck_tooth.dart';
import 'package:brainrot_adventure/actors/nuclear_eagle.dart';
import 'package:brainrot_adventure/actors/two_skulled_bird.dart';
import 'package:brainrot_adventure/components/audio_manager.dart';
import 'package:brainrot_adventure/components/bullet.dart';
import 'package:brainrot_adventure/components/chest.dart';
import 'package:brainrot_adventure/components/collision_block.dart';
import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:brainrot_adventure/components/collision_system.dart';
import 'package:brainrot_adventure/components/finish_flag.dart';
import 'package:brainrot_adventure/components/portal.dart';
import 'package:brainrot_adventure/components/summer_objects.dart';
import 'package:brainrot_adventure/components/summer_traps.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, running, jumping, falling, crouch }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with
        HasGameReference<BrainrotAdventure>,
        KeyboardHandler,
        CollisionCallbacks {
  String character;
  Player({super.position, this.character = "Wizard_Ducky"});

  late final SpriteAnimation idleAnimation,
      runningAnimation,
      jumpingAnimation,
      fallingAnimation,
      crouchAnimation;
  final double stepTime = 0.25;
  // double _accumulator = 0.0;
  // final double _fixedDeltaTime = 1 / 60;

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 300.0;
  Vector2 velocity = Vector2.zero();
  bool isFacingLeft = false;

  bool isJumping = false;
  final double gravity = 9.8;
  final double jumpForce = -600.0;
  final double terminalVelocity = 350;

  bool isOnGround = false;
  bool isCrouch = false;
  bool reachPortal = false;
  bool gotHit = false;

  Vector2 startingPosition = Vector2.all(0);
  Vector2 endingPosition = Vector2.all(0);

  List<CollisionBlock> collisionBlocks = [];
  RectangleHitbox playerHitBox = RectangleHitbox(
    position: Vector2(10, 6),
    size: Vector2(44, 58),
    anchor: Anchor.topLeft,
  );

  @override
  FutureOr<void> onLoad() {
    AudioManager.instance.startBgm('Pixel Daydream.mp3');
    _loadAllAnimation();
    add(playerHitBox);
    // debugMode = true;
    anchor = Anchor.topCenter;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // _accumulator += dt;

    // while (_accumulator >= _fixedDeltaTime) {
    if (!gotHit && !reachPortal) {
      _updatePlayerMovement(dt);
      _checkHorizontalCollisions();
      _applyGravity(dt);
      _checkVerticalCollisions();
      if (isCrouch) {
        current = PlayerState.crouch;
      } else if (!isOnGround) {
        current = velocity.y > 0 ? PlayerState.falling : PlayerState.jumping;
      } else if (isOnGround) {
        current = velocity.x != 0 ? PlayerState.running : PlayerState.idle;
      }
    }
    // _accumulator -= _fixedDeltaTime;
    // super.update(_fixedDeltaTime);
    super.update(dt);
    // }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _updateHorizontalDirection(keysPressed);
    _handleJumpInput(keysPressed);
    _handleCrouchInput(keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }

  void setSpawnPoint(Vector2 spawnPos) {
    startingPosition = spawnPos;
    position = startingPosition;
  }

  void setEndPoint(Vector2 endPos) {
    endingPosition = endPos;
    position = endPos;
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

    if (isJumpKeyPressed && !isJumping && isOnGround && !isCrouch) {
      AudioManager.instance.playSfx('jump.wav');
      isJumping = true;
      isOnGround = false;
      velocity.y = jumpForce;
    }
  }

  void _handleCrouchInput(Set<LogicalKeyboardKey> keysPressed) {
    final isDownKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS);

    isCrouch = isDownKeyPressed && isOnGround;
    if (isCrouch) {
      playerHitBox.size = Vector2(34, 34);
      playerHitBox.position = Vector2(15, 30);
    } else {
      playerHitBox.size = Vector2(44, 58);
      playerHitBox.position = Vector2(10, 6);
    }
  }

  void _loadAllAnimation() {
    idleAnimation = _spriteAnimation('idle', 5);
    runningAnimation = _spriteAnimation('run', 4);
    jumpingAnimation = _spriteAnimation('jump', 1);
    fallingAnimation = _spriteAnimation('fall', 1);
    crouchAnimation = _spriteAnimation('crouch', 1);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.crouch: crouchAnimation,
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
    if (!isCrouch) {
      velocity.x = _getHorizontalVelocity();
    } else {
      velocity.x = 0;
    }
    updateFacingDirection();
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

  void updateFacingDirection() {
    if (playerDirection == PlayerDirection.left && !isFacingLeft) {
      flipHorizontallyAroundCenter();
      isFacingLeft = true;
    } else if (playerDirection == PlayerDirection.right && isFacingLeft) {
      flipHorizontallyAroundCenter();
      isFacingLeft = false;
    }
  }

  void _applyGravity(double dt) {
    velocity.y += gravity;
    velocity.y = velocity.y.clamp(jumpForce, terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - playerHitBox.width / 2;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + playerHitBox.width / 2 + block.width;
            break;
          }
        }
      }
    }
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y =
                block.y - playerHitBox.height - playerHitBox.position.y;
            isOnGround = true;
            isJumping = false;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y =
                block.y - playerHitBox.height - playerHitBox.position.y;
            isOnGround = true;
            isJumping = false;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - playerHitBox.position.y;
            break;
          }
        }
      }
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (!reachPortal) {
      if (other is Chest) {
        other.chestCollideWithPlayer();
      }
      if (other is AcidLion) {
        _respawn();
      }
      if (other is ChubbyBuckTooth) {
        _respawn();
      }
      if (other is NuclearEagle) {
        _respawn();
      }
      if (other is TwoSkulledBird) {
        _respawn();
      }
      if (other is Bullet) {
        other.bulletCollideWithPlayer();
        _respawn();
      }
      if (other is Portal) {
        _reachPortal(other.getPortalType());
      }
      if (other is SummerTraps) {
        _respawn();
      }
      if (other is SummerObjects) {
        other.objectCollideWithPlayer();
      }
      if (other is FinishFlag) {
        other.flagCollideWithPlayer();
      }
      super.onCollisionStart(intersectionPoints, other);
    }
  }

  void _reachPortal(bool isStartingPortal) async {
    reachPortal = true;
    const waitToChangeDuration = Duration(seconds: 1);
    velocity = Vector2.all(0);
    Future.delayed(
      waitToChangeDuration,
      () => game.loadNextLevel(isStartingPortal),
    );
  }

  void _respawn() {
    gotHit = true;
    AudioManager.instance.playSfx('hit.wav');
    game.deductLive();
    velocity = Vector2.all(0);
    position = startingPosition;
    current = PlayerState.idle;
    Future.delayed(Duration(milliseconds: 500), () {
      gotHit = false;
    });
  }
}
