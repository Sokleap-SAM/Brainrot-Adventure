import 'dart:async';

import 'package:brainrot_adventure/players/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  String levelName;
  Level({required this.levelName});
  late TiledComponent level;

  @override
  Future<void> onLoad() async {
    level = await TiledComponent.load("summer_level_01.tmx", Vector2.all(16));
    add(level);

    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoint');

    for (final spawnPoint in spawnPointLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          final player = Player(
            character: "Wizard_Ducky",
            position: Vector2(spawnPoint.x, spawnPoint.y),
          );
          add(player);
          break;
        default:
      }
    }

    return super.onLoad();
  }
}
