import 'dart:async';

import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:flame/components.dart';

class Live extends SpriteComponent with HasGameReference<BrainrotAdventure> {
  Live({super.position});

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(game.images.fromCache('Hp/idle.png'));
    priority = 100;
    return super.onLoad();
  }

  void loseHp() {
    Future.delayed(Duration(milliseconds: 100), () {
      sprite = Sprite(game.images.fromCache('Hp/break1.png'));
    }).then((_) {
      Future.delayed(Duration(milliseconds: 100), () {
        sprite = Sprite(game.images.fromCache('Hp/break2.png'));
      }).then((_) {
        Future.delayed(Duration(milliseconds: 100), () {
          sprite = Sprite(game.images.fromCache('Hp/break3.png'));
        }).then((_) {
          // This final delay makes break3 visible for 0.5 seconds
          Future.delayed(Duration(milliseconds: 100), () {
            removeFromParent();
          });
        });
      });
    });
  }
}
