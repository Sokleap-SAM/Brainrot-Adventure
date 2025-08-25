import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:brainrot_adventure/data/game_data_manager.dart';
import 'package:flutter/material.dart';

class VictoryOverlay extends StatelessWidget {
  final BrainrotAdventure game;

  const VictoryOverlay({super.key, required this.game});

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
          width: 400, // Match GameOverScreen card width
          child: Card(
            color: Colors.indigo[900],
            elevation: 16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events, color: Colors.amber, size: 70),
                  SizedBox(height: 16),
                  Text(
                    'Victory!',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(2, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events, color: Colors.yellow, size: 24),
                      SizedBox(width: 8),
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
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 28),
                      SizedBox(width: 8),
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
                  SizedBox(height: 36),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/game',
                        arguments: game.levelNumber + 1,
                      );
                    },
                    icon: Icon(Icons.arrow_forward),
                    label: Text('Next Level', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[700],
                      minimumSize: Size(180, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/game',
                        arguments:
                            game.levelNumber, // Pass the current level number
                      );
                    },
                    icon: Icon(Icons.replay),
                    label: Text('Replay', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: Size(180, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      // game.overlays.clear();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/level_select',
                        (route) => false,
                      );
                    },
                    icon: Icon(Icons.home, color: Colors.white),
                    label: Text(
                      'Main Menu',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
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
