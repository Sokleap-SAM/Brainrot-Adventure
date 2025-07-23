import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/components.dart';

class CollectibleObject extends SpriteComponent
    with HasGameReference<BrainrotAdventure> {
  String filePath;
  CollectibleObject({super.position, this.filePath = "PauseButton"});

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(game.images.fromCache('Items/SummerObjects/$filePath.png'));
    priority = 100;
    return super.onLoad();
  }
}
