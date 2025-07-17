import 'dart:async';
import 'dart:ui';

import 'package:brainrot_adventure/levels/Button.dart';
import 'package:brainrot_adventure/levels/level.dart';
import 'package:brainrot_adventure/players/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

class BrainrotAdventure extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0x00000000);

  late CameraComponent cam;
  List<String> levelNames = ['summer_level_01', 'summer_level_01'];
  int currentLevelIndex = 0;
  late Player player;

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    _loadLevel();
    add(FpsTextComponent(position: Vector2(10, 10)));
    add(Button()); // Add the pause button to the game
    return super.onLoad();
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      player = Player(character: 'Wizard_Ducky');
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 1280,
        height: 720,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
    });
  }
}
