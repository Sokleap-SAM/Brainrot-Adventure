import 'package:brainrot_adventure/components/collision_block.dart';
import 'package:brainrot_adventure/actors/player.dart';

bool checkCollision(Player player, CollisionBlock block) {
  final fixedX = player.position.x - 22;
  final playerY = player.position.y + player.playerHitBox.position.y;
  final playerWidth = player.playerHitBox.width;
  final playerHeight = player.playerHitBox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedY = block.isPlatform ? (playerY + playerHeight) : playerY;
  return (fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX &&
      fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY);
}
