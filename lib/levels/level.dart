import 'dart:async';

import 'package:brainrot_adventure/levels/collision_block.dart';
import 'package:brainrot_adventure/players/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  Future<void> onLoad() async {
    level = await TiledComponent.load("summer_level_01.tmx", Vector2.all(16));
    add(level);
    _addSpawnPoint();
    _addCollision();
    return super.onLoad();
  }

  void _addSpawnPoint() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoint');
    if (spawnPointLayer == null) return;

    for (final spawnPoint in spawnPointLayer.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
        default:
      }
    }
  }

  void _addCollision() {
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>("Collision");
    if (collisionLayer == null) return;

    for (final collision in collisionLayer.objects) {
      final isPlatform = collision.class_ == 'platform';
      final block = CollisionBlock(
        position: Vector2(collision.x, collision.y),
        size: Vector2(collision.width, collision.height),
        isPlatform: isPlatform,
      );
      collisionBlocks.add(block);
      add(block);
    }
    player.collisionBlocks = collisionBlocks;
  }
}
