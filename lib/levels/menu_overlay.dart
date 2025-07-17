import 'package:flutter/material.dart';
import 'package:brainrot_adventure/brainrot_adventure.dart'; // Import your game class

class MenuOverlay extends StatelessWidget {
  // A reference to the game instance is often useful for controlling game state
  final BrainrotAdventure game;

  const MenuOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Use Material to get access to Theme data, shadows, etc.
      color: Colors.black54, // Semi-transparent black background
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
                game.overlays.remove('MenuOverlay'); // Remove the overlay
                game.resumeEngine(); // Resume the game
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(220, 60), // <-- Set fixed size for all buttons
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
            ElevatedButton(
              onPressed: () {
                // Handle restart game logic
                // For example, you might want to reset your game state or load a new level
                game.overlays.remove('MenuOverlay');
                game.resumeEngine();
                // Or if you want to completely restart the game, you might do something like:
                // game.resetGame(); // A method you'd need to implement in BrainrotAdventure
                print('Restart Game'); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(220, 60), // <-- Set fixed size for all buttons
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Restart',
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle options/settings logic
                print('Options');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(220, 60), // <-- Set fixed size for all buttons
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Options',
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
