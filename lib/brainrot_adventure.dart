import 'dart:async';
import 'dart:ui';

import 'package:brainrot_adventure/levels/audio_manager.dart';
import 'package:brainrot_adventure/levels/background.dart';
import 'package:brainrot_adventure/levels/button.dart';
import 'package:brainrot_adventure/levels/level.dart';
import 'package:brainrot_adventure/players/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class BrainrotAdventure extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0x00000000);

  // static const String pauseMenuIdentifier = 'PauseMenu';

  late CameraComponent cam;
  List<String> levelNames = ['summer_level_01', 'summer_level_01_part2'];
  int currentLevelIndex = 0;

  late Player player;

  List<String> audioList = [
    'Pixel Daydream.mp3',
    'jump.wav',
    'hit.wav',
    'collectObject.wav',
  ];
  AudioManager audioManager = AudioManager();

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    final stableBackground = StaticBackground(
      imagePath:
          'Background/summer.png', // Or 'summer.png' depending on your file and pubspec
      // You can explicitly set size if needed, e.g., size: Vector2(1280, 720),
      // If not set, it will default to gameRef.size in onLoad
    );
    await audioManager.init(audioList);
    // audioManager.startBgm('Pixel Daydream.mp3', 0.5);
    add(stableBackground);
    add(Button(audioManager: audioManager));

    _loadLevel();
    add(FpsTextComponent(position: Vector2(10, 10)));
    return super.onLoad();
  }

  // @override
  // KeyEventResult onKeyEvent(
  //   KeyEvent event, // <--- Using KeyEvent as the parameter type
  //   Set<LogicalKeyboardKey> keysPressed,
  // ) {
  //   // Toggle pause menu on 'P' key press
  //   // if (event is KeyEvent && keysPressed.contains(LogicalKeyboardKey.keyP)) { // This 'event is KeyEvent' check is redundant since the parameter is already KeyEvent
  //   if (keysPressed.contains(LogicalKeyboardKey.keyP)) {
  //     // Corrected and simplified check
  //     if (overlays.isActive(pauseMenuIdentifier)) {
  //       overlays.remove(pauseMenuIdentifier);
  //       resumeEngine();
  //       audioManager.resumeBgm(); // Resume the game when pause menu is closed
  //     } else {
  //       overlays.add(pauseMenuIdentifier);
  //       pauseEngine();
  //       audioManager.pauseBgm(); // Pause the game when pause menu is shown
  //     }
  //     return KeyEventResult.handled;
  //   }

  //   // Removed the 'S' key for secondary menu

  //   return super.onKeyEvent(event, keysPressed);
  // }

  void loadNextLevel(bool isStartingPortal) {
    removeWhere((component) => component is Level);
    if (isStartingPortal) {
      currentLevelIndex--;
      _loadLevel();
    } else {
      if (currentLevelIndex < levelNames.length - 1) {
        currentLevelIndex++;
        _loadLevel();
      } else {
        audioManager.stopBgm();
      }
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      player = Player(character: 'Wizard_Ducky', audioManager: audioManager);
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
