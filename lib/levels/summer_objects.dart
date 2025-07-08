import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/components.dart';

class SummerObjects extends SpriteAnimationComponent with HasGameReference<BrainrotAdventure> {
  final String summerobject;
  SummerObjects({this.summerobject = 'BeachBall', size}) : super(position: size);

  final double stepTime = 0.05;

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(game.images.fromCache('Items/SummberObjects/$summerobject.png'), SpriteAnimationData.sequenced(
      amount: 1, 
      stepTime: stepTime,
      textureSize: Vector2.all(64), 
    ));
    return super.onLoad();
  }
}

