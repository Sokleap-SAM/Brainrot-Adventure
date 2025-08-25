import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:brainrot_adventure/data/game_data_manager.dart';
import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final BrainrotAdventure game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final int highScore = GameDataManager.getHighScoreForLevel(
      game.levelNumber,
    );
    final int score = game.currentScore;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 140, 209, 244),
      body: Center(
        child: SizedBox(
          width: 400, // Match VictoryScreen card width
          child: Card(
            color: Colors.indigo[900],
            elevation: 16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                32,
              ), // Match VictoryScreen radius
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 48,
              ), // Match VictoryScreen padding
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.redAccent,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Game Over',
                    style: TextStyle(
                      fontSize: 44,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events, color: Colors.yellow, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'High Score: $highScore',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'Score: $score',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/game',
                        arguments:
                            game.levelNumber, // Pass the current level number
                      );
                    },
                    icon: Icon(Icons.refresh, color: Colors.white),
                    label: Text(
                      'Retry',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 18, 144, 211),
                      minimumSize: Size(160, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/level_select');
                    },
                    icon: Icon(Icons.home, color: Colors.white),
                    label: Text(
                      'Main Menu',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 18, 144, 211),
                      minimumSize: Size(160, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
