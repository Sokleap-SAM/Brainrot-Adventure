import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Button extends SpriteComponent
    with HasGameReference<BrainrotAdventure>, TapCallbacks {
  Button();

  final double margin = 32;
  final double buttonSize = 64; 

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('Button/PauseButton/PauseButton.png'));
    position = Vector2(60, 30);
    priority = 10; 
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) { 
    game.overlays.add('MenuOverlay');
    game.pauseEngine();
    super.onTapUp(event);
  }
}
