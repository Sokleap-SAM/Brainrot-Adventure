import 'dart:async';
import 'dart:ui';

import 'package:brainrot_adventure/levels/level.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class TestAdventure extends FlameGame {
  late final CameraComponent cam;
  final worlds = Level();

  @override
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(
      world: worlds,
      width: 1280,
      height: 720,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, worlds]);
    return super.onLoad();
  }

  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);
}
