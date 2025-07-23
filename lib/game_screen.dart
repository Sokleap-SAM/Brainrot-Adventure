import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:brainrot_adventure/levels/menu_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = BrainrotAdventure();

    return Scaffold(
      body: GameWidget<BrainrotAdventure>(
        game: game,
        overlayBuilderMap: {
          'MenuOverlay': (BuildContext context, BrainrotAdventure game) {
            return MenuOverlay(game: game);
          },
        },
      ),
    );
  }
}
