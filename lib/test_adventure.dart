import 'dart:async';
import 'dart:ui';

import 'package:brainrot_adventure/levels/level.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class TestAdventure extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  late final CameraComponent cam;
  final worlds = Level(levelName: 'summer_level_01');

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();
    final world = Level(levelName: 'summer_level_01');
    cam = CameraComponent.withFixedResolution(
      world: worlds,
      width: 1280,
      height: 720,
    );
    addAll([worlds, cam]);
    cam.viewfinder.anchor = Anchor.topLeft;
    return super.onLoad();
  }
}
