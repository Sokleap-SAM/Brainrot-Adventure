import 'dart:async';
import 'dart:ui';

import 'package:brainrot_adventure/levels/level.dart';
import 'package:brainrot_adventure/players/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';


class BrainrotAdventure extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0x00000000);

  late final CameraComponent cam;
  Player player = Player(character: 'Wizard_Ducky');

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    final world = Level(levelName: 'summer_level_01', player: player);

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 1280,
      height: 720,
    );
    addAll([world, cam]);
    cam.viewfinder.anchor = Anchor.topLeft;
    add(FpsTextComponent(position: Vector2(10, 10)));
    return super.onLoad();
  }
}
