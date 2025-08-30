import 'dart:async';

import 'package:brainrot_adventure/components/audio_manager.dart';
import 'package:brainrot_adventure/components/button.dart';
import 'package:brainrot_adventure/components/collectible_object.dart';
import 'package:brainrot_adventure/components/level.dart';
import 'package:brainrot_adventure/components/live.dart';
import 'package:brainrot_adventure/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class BrainrotAdventure extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late Player player;
  late CameraComponent cam;

  final VoidCallback? onVictory;
  final VoidCallback? onGameOver;

  final int levelNumber;
  late Map<String, int> collectibleObjects;
  final List<String> maps;
  double remainingTime;

  int currentScore = 0;
  int currentMapIndex = 0;
  List<Live> lives = [];
  int hp = 5;
  List<String> audioList = [
    'Pixel Daydream.mp3',
    'jump.wav',
    'hit.wav',
    'collectObject.wav',
  ];

  final Map<String, TextComponent> _objectTexts = {};
  final Map<String, int> _currentCollection = {};
  final Map<String, bool> _isObjectsCollected = {};

  late Timer _gameTimer;

  late TextComponent _timerText;

  BrainrotAdventure({
    required this.levelNumber,
    this.onVictory,
    this.onGameOver,
    required this.collectibleObjects,
    required this.maps,
    required this.remainingTime,
  });

  @override
  Color backgroundColor() => const Color(0x00000000);

  void _showHp() {
    final double hpSize = 64;
    final double margin = 20;
    double xPosition = 450 - margin - hpSize;
    final double spacing = hpSize;

    for (int i = 0; i < hp; i++) {
      lives.add(Live(position: Vector2(xPosition, 30)));
      cam.viewport.add(lives[i]);
      xPosition -= spacing;
    }
  }

  void deductLive() {
    hp--;
    final lastLive = lives.removeAt(0);
    lastLive.loseHp();
    if (hp == 0) {
      _calculateScore();
      onGameOver?.call();
    }
  }

  void _initialCollectibleObjects() {
    for (var entry in collectibleObjects.entries) {
      _currentCollection[entry.key] = 0;
      _isObjectsCollected[entry.key] = false;
    }
  }

  void _showCollectibleObjects() {
    final double objectSize = 64;
    final double margin = 20;
    double xPosition = 1280 - margin - objectSize;
    final double spacing = objectSize;
    for (var entry in collectibleObjects.entries) {
      cam.viewport.add(
        CollectibleObject(
          position: Vector2(xPosition, 30),
          filePath: entry.key,
        ),
      );
      _addTextComponent(entry.key, xPosition);
      _currentCollection[entry.key] = 0;
      xPosition -= spacing;
    }
  }

  void _addTextComponent(String objectName, double xPosition) {
    final textComponent = TextComponent(
      text: "0/${collectibleObjects[objectName]}",
      position: Vector2(xPosition + 15, 100),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20.0,
          color: Color.fromRGBO(200, 200, 200, 1),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    _objectTexts[objectName] = textComponent;
    cam.viewport.add(textComponent);
  }

  void updateCollectibleObject(String objectName) {
    int requirement = collectibleObjects[objectName]!;
    int currentCount = _currentCollection[objectName]! + 1;
    updateTextComponent(objectName, currentCount, requirement);
    _currentCollection[objectName] = currentCount;
  }

  void updateTextComponent(
    String objectName,
    int currentCount,
    int requirement,
  ) {
    TextComponent updateTextComponent = _objectTexts[objectName]!;
    updateTextComponent.text = "$currentCount/$requirement";
    updateTextComponent.textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 20.0,
        color: Color.fromRGBO(6, 64, 43, 1),
        fontWeight: FontWeight.bold,
      ),
    );
    _objectTexts[objectName] = updateTextComponent;
  }

  void checkCurrentWorldObject() {
    for (var objectName in collectibleObjects.keys) {
      if (collectibleObjects[objectName] == _currentCollection[objectName]) {
        _isObjectsCollected[objectName] = true;
      }
    }
  }

  void checkVictory() {
    for (var object in collectibleObjects.entries) {
      if (object.value != _currentCollection[object.key]) {
        return;
      }
    }
    _calculateScore();
    onVictory?.call();
  }

  void _calculateScore() {
    // 1 star >= 500 && < 1500,
    // 2 star >= 1500 && < 3000,
    // 3 star >= 3000
    double timeBonus = 0;
    if (hp > 0) {
      timeBonus = remainingTime * 200;
    }
    double objectBonus = 0;
    for (var entry in _currentCollection.entries) {
      int collected = entry.value;
      objectBonus += collected * (1000 / collectibleObjects.length);
    }
    currentScore = (timeBonus + objectBonus).round();
  }

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    final parallaxComponent = await loadParallaxComponent(
      [
        ParallaxImageData('Background/beach-1-1.png'),
        ParallaxImageData('Background/beach-1-2.png'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.2, 0),
      size: size,
    );

    final stationaryParallaxComponent = await loadParallaxComponent(
      [ParallaxImageData('Background/beach-1-3.png')],
      baseVelocity: Vector2(0, 0),
      velocityMultiplierDelta: Vector2(0, 0),
      size: size,
    );

    add(parallaxComponent);
    add(stationaryParallaxComponent);
    await AudioManager.instance.init(audioList);

    cam = CameraComponent.withFixedResolution(
      world: World(),
      width: 1280,
      height: 720,
    );
    cam.viewfinder.anchor = Anchor.center;
    add(cam);

    createTimerText();
    _gameTimer = Timer(
      1.0,
      onTick: _updateTimer,
      repeat: true,
      autoStart: false,
    );

    _initialCollectibleObjects();
    _showHp();
    _showCollectibleObjects();
    cam.viewport.add(Button());
    cam.viewport.add(_timerText);

    _loadLevel(false);
    _showLevelGuide();

    return super.onLoad();
  }

  void _showLevelGuide() {
    switch (levelNumber) {
      case 1:
        overlays.add('LevelGuideOverlay');
        break;
      case 5:
        overlays.add('LevelGuideOverlay');
        break;
      case 8:
        overlays.add('LevelGuideOverlay');
        break;
      default:
        startTimer();
        break;
    }
  }

  void loadNextLevel(bool isStartingPortal) {
    checkCurrentWorldObject();
    removeWhere((component) => component is Level);
    if (isStartingPortal) {
      currentMapIndex--;
      _loadLevel(isStartingPortal);
    } else {
      if (currentMapIndex < maps.length - 1) {
        currentMapIndex++;
        _loadLevel(isStartingPortal);
      } else {
        AudioManager.instance.stopBgm();
      }
    }
  }

  void _loadLevel(bool isStartingPortal) {
    player = Player(character: 'Wizard_Ducky');

    Level world = Level(
      player: player,
      levelName: maps[currentMapIndex],
      isObjectsCollected: _isObjectsCollected,
      isStartingPortal: isStartingPortal,
    );

    add(world);
    cam.world = world;
    cam.follow(player);
  }

  void createTimerText() {
    int minutes = (remainingTime / 60).floor();
    int seconds = (remainingTime % 60).toInt();
    _timerText = TextComponent(
      text:
          'Time remaining: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
      position: Vector2(20, 100),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20.0,
          color: Color.fromRGBO(200, 200, 200, 1),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void startTimer() {
    _gameTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_gameTimer.isRunning()) {
      _gameTimer.update(dt);
    }
  }

  void _updateTimer() {
    remainingTime -= 1;
    int minutes = (remainingTime / 60).floor();
    int seconds = (remainingTime % 60).toInt();

    _timerText.text =
        'Time remaining: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    if (remainingTime <= 0) {
      _gameTimer.stop();
      _calculateScore();
      onGameOver?.call();
    }
  }
}
