import 'dart:async';

import 'package:brainrot_adventure/actors/acid_lion.dart';
import 'package:brainrot_adventure/actors/chubby_buck_tooth.dart';
import 'package:brainrot_adventure/actors/nuclear_eagle.dart';
import 'package:brainrot_adventure/actors/two_skulled_bird.dart';
import 'package:brainrot_adventure/components/chest.dart';
import 'package:brainrot_adventure/components/collision_block.dart';
import 'package:brainrot_adventure/components/finish_flag.dart';
import 'package:brainrot_adventure/components/portal.dart';
import 'package:brainrot_adventure/components/summer_traps.dart';
import 'package:brainrot_adventure/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  String levelName;
  final Player player;
  bool isStartingPortal;
  late Vector2 portalPosition;

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];
  Map<String, bool> isObjectsCollected;

  Level({
    required this.levelName,
    required this.player,
    required this.isObjectsCollected,
    required this.isStartingPortal,
  });

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
            name: spawnPoint.name,
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
            isVerticalMovement: spawnPoint.properties.getValue(
              'isVerticalMovement',
            ),
            velocity: spawnPoint.properties.getValue('velocity'),
            negativeRange: spawnPoint.properties.getValue('leftTile') * 16,
            positiveRange: spawnPoint.properties.getValue('rightTile') * 16,
          );
          add(summerTraps);
          break;
        default:
      }
    }

    for (final spawnPoint in spawnPointLayer.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.setSpawnPoint(Vector2(spawnPoint.x, spawnPoint.y));
          if (isStartingPortal) {
            player.setEndPoint(
              Vector2(portalPosition.x + 100, portalPosition.y),
            );
          }
          add(player);
          break;
        case 'Chest':
          if (isObjectsCollected[spawnPoint.name] == false) {
            final chest = Chest(
              objectName: spawnPoint.name,
              size: Vector2(spawnPoint.width, spawnPoint.height),
              position: Vector2(spawnPoint.x, spawnPoint.y),
              spriteAmount: spawnPoint.properties.getValue('SpriteAmount'),
              isEmpty: spawnPoint.properties.getValue('isEmpty'),
            );
            add(chest);
          }
          break;
        case 'Enemy':
          if (spawnPoint.name == "Chubby Buck Tooth") {
            final enemy = ChubbyBuckTooth(
              position: spawnPoint.position,
              size: spawnPoint.size,
              enemyName: spawnPoint.name,
              negativeRange:
                  spawnPoint.properties.getValue('positiveTile') * 16,
              positiveRange:
                  spawnPoint.properties.getValue('negativeTile') * 16,
              velocity: spawnPoint.properties.getValue('velocity'),
            );
            add(enemy);
          } else if (spawnPoint.name == "Two Skulled Bird") {
            final enemy = TwoSkulledBird(
              position: spawnPoint.position,
              size: spawnPoint.size,
              enemyName: spawnPoint.name,
              negativeRange:
                  spawnPoint.properties.getValue('positiveTile') * 16,
              positiveRange:
                  spawnPoint.properties.getValue('negativeTile') * 16,
              velocity: spawnPoint.properties.getValue('velocity'),
            );
            add(enemy);
          } else if (spawnPoint.name == "Acid Lion") {
            final enemy = AcidLion(
              position: spawnPoint.position,
              size: spawnPoint.size,
              enemyName: spawnPoint.name,
              firingRangeInTiles: spawnPoint.properties.getValue(
                'firingRangeInTiles',
              ),
            );
            add(enemy);
          } else if (spawnPoint.name == 'Nuclear Eagle') {
            final enemy = NuclearEagle(
              position: spawnPoint.position,
              size: spawnPoint.size,
              enemyName: spawnPoint.name,
              negativeRange:
                  spawnPoint.properties.getValue('negativeTile') * 16,
              positiveRange:
                  spawnPoint.properties.getValue('positiveTile') * 16,
              velocity: spawnPoint.properties.getValue('velocity'),
              firingRangeInTiles: spawnPoint.properties.getValue(
                'firingRangeInTiles',
              ),
            );
            add(enemy);
          }
          break;
        case 'FinishFlag':
          final finishFlag = FinishFlag(
            position: spawnPoint.position,
            name: spawnPoint.name,
            size: spawnPoint.size,
            spriteAmount: spawnPoint.properties.getValue('SpriteAmount'),
          );
          add(finishFlag);
        default:
      }
    }
  }

  void _addCollision() {
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>("Collision");
    if (collisionLayer == null) return;

    for (final collision in collisionLayer.objects) {
      final isPlatform = collision.class_ == 'Platform';
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
