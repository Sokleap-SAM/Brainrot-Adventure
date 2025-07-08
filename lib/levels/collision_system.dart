import 'package:brainrot_adventure/levels/collision_block.dart';
import 'package:brainrot_adventure/players/player.dart';

bool checkCollision(Player player, CollisionBlock block) {
  final playerX = player.position.x + player.playerHitBox.position.x;
  final playerY = player.position.y + player.playerHitBox.position.y;
  final playerWidth = player.playerHitBox.width;
  final playerHeight = player.playerHitBox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.isFacingLeft
      ? playerX
      : (playerX -
            2 * player.playerHitBox.position.x -
            player.playerHitBox.width);
  final fixedY = block.isPlatform ? (playerY + playerHeight) : playerY;
  return (fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX &&
      fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY);
}
