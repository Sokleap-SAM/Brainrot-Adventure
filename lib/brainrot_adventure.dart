import 'dart:async';
import 'dart:ui';

import 'package:brainrot_adventure/levels/audio_manager.dart';
import 'package:brainrot_adventure/levels/background.dart';
import 'package:brainrot_adventure/levels/button.dart';
import 'package:brainrot_adventure/levels/collectible_object.dart';
import 'package:brainrot_adventure/levels/level.dart';
import 'package:brainrot_adventure/levels/live.dart';
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

  List<Live> lives = [];
  int hp = 5;

  Map<String, int> collectibleObjects = {"BeachBall": 1};

  void initialHeart() {
    final double hpSize = 64;
    final double margin = 20;
    double xPosition = 600 - margin - hpSize;
    final double spacing = hpSize;

    for (int i = 0; i < hp; i++) {
      lives.add(Live(position: Vector2(xPosition, 20)));
      cam.viewport.add(lives[i]);
      xPosition -= spacing;
    }
  }

  void deductLive() {
    hp--;
    final lastLive = lives.removeAt(0);
    lastLive.removeFromParent();
  }

  void showCollectibleObjects() {
    final double objectSize = 64;
    final double margin = 20;
    double xPosition = 1280 - margin - objectSize;
    final double spacing = objectSize;
    for (var entry in collectibleObjects.entries) {
      cam.viewport.add(
        CollectibleObject(
          position: Vector2(xPosition, 20),
          filePath: entry.key,
        ),
      );
      final textComponent = TextComponent(
        text: "0/${entry.value}",
        position: Vector2(xPosition, 100),
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 3.0,
                color: Colors.black,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
      );
      cam.viewport.add(textComponent);
      xPosition -= spacing;
    }
  }

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    final stableBackground = StaticBackground(
      imagePath: 'Background/summer.png',
      size: Vector2(1280, 720),
    );
    add(stableBackground);
    await AudioManager.instance.init(audioList);

    _loadLevel();
    add(FpsTextComponent(position: Vector2(10, 10)));
    return super.onLoad();
  }

  // @override
  // KeyEventResult onKeyEvent(
  //   KeyEvent event,
  //   Set<LogicalKeyboardKey> keysPressed,
  // ) {
  // if (event is KeyEvent && keysPressed.contains(LogicalKeyboardKey.keyP)) {
  //   if (keysPressed.contains(LogicalKeyboardKey.keyP)) {
  //     // Corrected and simplified check
  //     if (overlays.isActive(pauseMenuIdentifier)) {
  //       overlays.remove(pauseMenuIdentifier);
  //       resumeEngine();
  //       audioManager.resumeBgm();
  //     } else {
  //       overlays.add(pauseMenuIdentifier);
  //       pauseEngine();
  //       audioManager.pauseBgm();
  //     }
  //     return KeyEventResult.handled;
  //   }
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
        AudioManager.instance.stopBgm();
      }
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(milliseconds: 100), () {
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
      cam.viewport.add(Button());
      initialHeart();
      showCollectibleObjects();
    });
  }
}
