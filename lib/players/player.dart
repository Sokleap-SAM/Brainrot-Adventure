import 'dart:async';

import 'package:brainrot_adventure/test_adventure.dart';
import 'package:flame/components.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent
    with HasGameReference<TestAdventure> {
  String character;
  Player({position, required this.character}) : super(position: position);

  late final SpriteAnimation idleAnimation, runningAnimation;
  final double stepTime = 0.04;

  @override
  FutureOr<void> onLoad() {
    loadAllAnimation();
    return super.onLoad();
  }

  void loadAllAnimation() {
    idleAnimation = spriteAnimation('idle', 5);
    runningAnimation = spriteAnimation('run', 4);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

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
}
