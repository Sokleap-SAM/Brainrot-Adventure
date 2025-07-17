import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:brainrot_adventure/levels/audio_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Button extends SpriteComponent
    with HasGameReference<BrainrotAdventure>, TapCallbacks {
  final AudioManager audioManager;
  Button(this.audioManager);

  final double margin = 32;
  final double buttonSize = 64;

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(
      game.images.fromCache('Button/PauseButton/PauseButton.png'),
    );
    position = Vector2(60, 30);
    priority = 10;
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.overlays.add('MenuOverlay');
    audioManager.pauseBgm();
    game.pauseEngine();
    super.onTapUp(event);
  }
}
