import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/components.dart';

class Live extends SpriteComponent with HasGameReference<BrainrotAdventure> {
  Live({super.position});

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(
      game.images.fromCache('Button/PauseButton/PauseButton.png'),
    );
    priority = 100;
    return super.onLoad();
  }
}
