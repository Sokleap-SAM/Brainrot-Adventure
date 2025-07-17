import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:brainrot_adventure/levels/audio_manager.dart';
import 'package:brainrot_adventure/levels/menu_overlay.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = BrainrotAdventure(); // Instantiate your game

    return MaterialApp(
      title: 'Brainrot Adventure',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GameWidget<BrainrotAdventure>(
        game: game,
        // Define your overlays here
        overlayBuilderMap: {
          'MenuOverlay': (BuildContext context, BrainrotAdventure game) {
            return MenuOverlay(
              game: game,
              audioManager: game.audioManager,
            ); // Pass the game instance to your overlay
          },
          // Add other overlays here if you have them (e.g., 'GameOverOverlay')
        },
        // Optionally, define what overlay to show when the game starts
        // initialActiveOverlays: const ['MenuOverlay'], // If you want the menu to show on startup
      ),
    );
  }
}
