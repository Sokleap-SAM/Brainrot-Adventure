import 'dart:async';

import 'package:brainrot_adventure/test_adventure.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<TestAdventure>, KeyboardHandler {
  String character;
  Player({position, this.character = "Wizard_Ducky"})
    : super(position: position);

  late final SpriteAnimation idleAnimation, runningAnimation;
  final double stepTime = 0.25;

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 150;
  Vector2 velocity = Vector2.zero();
  bool isFacingLeft = false;

  @override
  FutureOr<void> onLoad() {
    loadAllAnimation();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    updatePlayerMovement(dt);
    print("Player position: (${position.x}, ${position.y})");
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
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

    return super.onKeyEvent(event, keysPressed);
  }

  void loadAllAnimation() {
    idleAnimation = spriteAnimation('idle', 5);
    runningAnimation = spriteAnimation('run', 4);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };
    flipHorizontallyAroundCenter();
    current = PlayerState.idle;
  }

  SpriteAnimation spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Player/$character/$state.png"),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(64),
      ),
    );
  }

  void updatePlayerMovement(double dt) {
    double directionX = 0.0;
    double directionY = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (!isFacingLeft) {
          flipHorizontallyAroundCenter();
          isFacingLeft = true;
        }
        directionX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (isFacingLeft) {
          flipHorizontallyAroundCenter();
          isFacingLeft = false;
        }
        directionX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
    }

    velocity = Vector2(directionX, 0.0);
    position.add(velocity * dt);
  }
}
