import 'dart:async';

import 'package:brainrot_adventure/levels/collision_block.dart';
import 'package:brainrot_adventure/levels/portal.dart';
import 'package:brainrot_adventure/levels/summer_objects.dart';
import 'package:brainrot_adventure/levels/summer_traps.dart';
import 'package:brainrot_adventure/players/enemy.dart';
import 'package:brainrot_adventure/players/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  String levelName;
  final Player player;
  bool isStartingPortal;
  late Vector2 portalPosition;

  Level({
    required this.levelName,
    required this.player,
    required this.isCollectObjectList,
    required this.isStartingPortal,
  });

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];
  Map<String, bool> isCollectObjectList;

  @override
  Future<void> onLoad() async {
    level = await TiledComponent.load("$levelName.tmx", Vector2.all(16));
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
        case 'Portal':
          final portal = Portal(
            position: spawnPoint.position,
            size: spawnPoint.size,
            // name: spawnPoint.name,
            isStartingPortal: spawnPoint.properties.getValue(
              "isStartingPortal",
            ),
          );
          portalPosition = spawnPoint.position;
          add(portal);
          break;
        case 'SummerTraps':
          final summerTraps = SummerTraps(
            summertraps: spawnPoint.name,
            size: Vector2(spawnPoint.width, spawnPoint.height),
            position: Vector2(spawnPoint.x, spawnPoint.y),
          );
          add(summerTraps);
          break;
        default:
      }
    }

    for (final spawnPoint in spawnPointLayer.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          print(isStartingPortal);
          if (!isStartingPortal) {
            player.setSpawnPoint(Vector2(spawnPoint.x, spawnPoint.y));
          } else {
            player.setSpawnPoint(
              Vector2(portalPosition.x - 44, portalPosition.y),
            );
            player.flipHorizontallyAroundCenter();
            player.isFacingLeft = true;
          }
          add(player);
          break;
        case 'Object':
          if (!isCollectObjectList[spawnPoint.name]!) {
            final summerObject = SummerObjects(
              summerobject: spawnPoint.name,
              size: Vector2(spawnPoint.width, spawnPoint.height),
              position: Vector2(spawnPoint.x, spawnPoint.y),
              spriteAmount: spawnPoint.properties.getValue('SpriteAmount'),
            );
            add(summerObject);
          }
          break;
        case 'Enemy':
          final enemy = Enemy(
            position: spawnPoint.position,
            size: spawnPoint.size,
            enemyName: spawnPoint.name,
          );
          add(enemy);
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
