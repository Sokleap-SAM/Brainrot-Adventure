import 'dart:io';
import 'package:brainrot_adventure/levels/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:brainrot_adventure/brainrot_adventure.dart';

class MenuOverlay extends StatelessWidget { 
  final BrainrotAdventure game;
  final AudioManager audioManager;

  const MenuOverlay({
    super.key,
    required this.game,
    required this.audioManager,
  });

  @override
  Widget build(BuildContext context) { 
    return Material(
      color: Colors.black54,
      child: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Menu',
              style: TextStyle(
                fontSize: 48.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove('MenuOverlay');
                audioManager.resumeBgm();
                game.resumeEngine();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(
                  220,
                  60,
                ), // <-- Set fixed size for all buttons
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Resume',
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove('MenuOverlay');
                game.resumeEngine();
                print('Resume');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(
                  220,
                  60,
                ), // <-- Set fixed size for all buttons
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Settings',
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                exit(0); // This will close the app
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(
                  220,
                  60,
                ), // <-- Set fixed size for all buttons
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
