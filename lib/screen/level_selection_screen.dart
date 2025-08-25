import 'package:brainrot_adventure/data/game_data.dart';
import 'package:brainrot_adventure/data/game_data_manager.dart';
import 'package:flutter/material.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int _currentChapter = 1;
  static const int _levelsPerChapter = 9;
  static const int _levelsPerRow = 3;
  static const int _totalChapters = 3;

  late Future<GameData> _gameDataFuture;

  @override
  void initState() {
    super.initState();
    _gameDataFuture = Future.value(GameDataManager.loadGameProgress());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GameData>(
      future: _gameDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final GameData gameData = snapshot.data!;
          final List<int> completedLevels = gameData.completedLevels;

          final int startLevel = (_currentChapter - 1) * _levelsPerChapter + 1;

          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Background/game.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chapter $_currentChapter',
                      style: const TextStyle(
                        fontSize: 50.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 300.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _levelsPerRow,
                                crossAxisSpacing: 30.0,
                                mainAxisSpacing: 30.0,
                              ),
                          itemCount: _levelsPerChapter,
                          itemBuilder: (context, index) {
                            final int levelNumber = startLevel + index;
                            final bool isPreviousLevelCompleted =
                                (levelNumber == 1) ||
                                completedLevels.contains(levelNumber - 1);
                            final bool isUnlocked = isPreviousLevelCompleted;
                            final int highScore =
                                GameDataManager.getHighScoreForLevel(
                                  levelNumber,
                                );
                            final int starRating = _getStarRatingFromScore(
                              highScore,
                            );

                            return _buildLevelCard(
                              context,
                              levelNumber,
                              starRating,
                              isUnlocked,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    _buildNavigationButtons(context),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  int _getStarRatingFromScore(int score) {
    // 1 star >= 500 && < 1500,
    // 2 star >= 1500 && < 3000,
    // 3 star >= 3000
    if (score >= 3000) return 3;
    if (score >= 1500) return 2;
    if (score >= 500) return 1;
    return 0; // Not completed
  }

  Widget _buildLevelCard(
    BuildContext context,
    int levelNumber,
    int starRating,
    bool isUnlocked,
  ) {
    final bool isCompleted = starRating > 0;

    final Color cardColor = isUnlocked
        ? (isCompleted ? Colors.green.shade700 : Colors.blue.shade700)
        : Colors.grey.shade700;

    final Widget cardContent = isUnlocked
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$levelNumber',
                style: const TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildStarRating(starRating),
            ],
          )
        : const Icon(Icons.lock, size: 50, color: Colors.white);

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: cardColor,
      child: InkWell(
        onTap: isUnlocked
            ? () {
                _showLevelMiniMenu(context, levelNumber, starRating);
              }
            : null,
        child: cardContent,
      ),
    );
  }

  Widget _buildStarRating(int starRating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        if (index < starRating) {
          return const Icon(Icons.star, color: Colors.yellow, size: 32.0);
        } else {
          return const Icon(
            Icons.star_border,
            color: Colors.yellow,
            size: 32.0,
          );
        }
      }),
    );
  }

  void _showLevelMiniMenu(
    BuildContext context,
    int levelNumber,
    int starRating,
  ) {
    int highscore = GameDataManager.getHighScoreForLevel(levelNumber);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: 500,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Level $levelNumber',
                      style: const TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: Colors.yellow,
                          size: 24,
                        ),
                        Text(
                          'High Score: $highscore',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildStarRating(starRating),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Navigator.of(
                          context,
                        ).pushNamed('/game', arguments: levelNumber);
                        setState(() {
                          _gameDataFuture = Future.value(
                            GameDataManager.loadGameProgress(),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Play'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context).pushNamed('/level_select');
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMenuButton(context, 'Back', () {
            Navigator.of(context).pushReplacementNamed('/');
          }),
          Row(
            children: [
              if (_currentChapter > 1)
                _buildMenuButton(context, 'Previous', () {
                  setState(() {
                    _currentChapter--;
                  });
                }),
              if (_currentChapter > 1 && _currentChapter < _totalChapters)
                const SizedBox(width: 20),
              if (_currentChapter < _totalChapters)
                _buildMenuButton(context, 'Next', () {
                  setState(() {
                    _currentChapter++;
                  });
                }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        textStyle: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.white, width: 3),
        ),
        elevation: 10,
        shadowColor: Colors.black,
      ),
      child: Text(text),
    );
  }
}
