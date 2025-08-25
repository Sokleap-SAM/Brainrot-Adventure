import 'package:brainrot_adventure/brainrot_adventure.dart';
import 'package:brainrot_adventure/components/audio_manager.dart';
import 'package:brainrot_adventure/data/game_data_manager.dart';
import 'package:brainrot_adventure/data/level_data.dart';
import 'package:brainrot_adventure/data/level_data_loader.dart';
import 'package:brainrot_adventure/overlays/game_over_overlay.dart';
import 'package:brainrot_adventure/overlays/level_guide_overlay.dart';
import 'package:brainrot_adventure/overlays/menu_overlay.dart';
import 'package:brainrot_adventure/overlays/victory_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:video_player/video_player.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late VideoPlayerController _victoryVideoController;
  late VideoPlayerController _gameOverVideoController;
  late BrainrotAdventure _game;
  bool _showVideo = false;
  bool _isLoading = true;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    _victoryVideoController = VideoPlayerController.asset(
      'assets/videos/victory.mp4',
    );
    _gameOverVideoController = VideoPlayerController.asset(
      'assets/videos/game_over.mp4',
    );
    _initializeVictoryController();
    _initializeGameOverVideoController();
  }

  void _initializeVictoryController() async {
    await _victoryVideoController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  void _initializeGameOverVideoController() async {
    await _gameOverVideoController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _victoryVideoController.dispose();
    _gameOverVideoController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _initializeGame();
    }
  }

  Future<void> _initializeGame() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    int? level = (args is int) ? args : 1;
    final LevelData levelData = LevelDataLoader.getLevelData(level);

    _game = BrainrotAdventure(
      levelNumber: level,
      onVictory: _playVideo,
      onGameOver: () {
        isGameOver = true;
        _playVideo();
      },
      collectibleObjects: Map<String, int>.from(levelData.objects),
      maps: levelData.maps,
      remainingTime: levelData.timeLimitInSeconds.toDouble(),
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _playVideo() {
    if (_showVideo) return;

    _game.overlays.clear();

    setState(() {
      _showVideo = true;
    });

    if (isGameOver) {
      _gameOverVideoController
        ..seekTo(Duration.zero)
        ..play();

      _gameOverVideoController.addListener(_onGameOverVideoCompletion);
      return;
    }

    _victoryVideoController
      ..seekTo(Duration.zero)
      ..play();

    _victoryVideoController.addListener(_onVictoryVideoCompletion);
  }

  void _onVictoryVideoCompletion() {
    if (_victoryVideoController.value.position >=
            _victoryVideoController.value.duration &&
        _showVideo) {
      _victoryVideoController.removeListener(_onVictoryVideoCompletion);

      setState(() {
        _showVideo = false;
      });

      _game.pauseEngine();
      AudioManager.instance.stopBgm();
      final int highScore = GameDataManager.getHighScoreForLevel(
        _game.levelNumber,
      );
      if (_game.currentScore > highScore) {
        GameDataManager.saveGameProgress(_game.levelNumber, _game.currentScore);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _game.overlays.add('VictoryOverlay');
        }
      });
    }
  }

  void _onGameOverVideoCompletion() {
    if (_gameOverVideoController.value.position >=
            _gameOverVideoController.value.duration &&
        _showVideo) {
      _gameOverVideoController.removeListener(_onGameOverVideoCompletion);

      setState(() {
        _showVideo = false;
      });

      _game.pauseEngine();
      AudioManager.instance.stopBgm();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _game.overlays.add('GameOverOverlay');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showVideo &&
        !isGameOver &&
        _victoryVideoController.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: AspectRatio(
            aspectRatio: _victoryVideoController.value.aspectRatio,
            child: VideoPlayer(_victoryVideoController),
          ),
        ),
      );
    }

    if (_showVideo &&
        isGameOver &&
        _gameOverVideoController.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: AspectRatio(
            aspectRatio: _gameOverVideoController.value.aspectRatio,
            child: VideoPlayer(_gameOverVideoController),
          ),
        ),
      );
    }

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: GameWidget<BrainrotAdventure>(
        game: _game,
        overlayBuilderMap: {
          'MenuOverlay': (BuildContext context, BrainrotAdventure game) {
            return MenuOverlay(game: game);
          },
          'LevelGuideOverlay': (BuildContext context, BrainrotAdventure game) {
            return LevelGuideOverlay(game: game);
          },
          'GameOverOverlay': (BuildContext context, BrainrotAdventure game) {
            return GameOverOverlay(game: _game);
          },
          'VictoryOverlay': (BuildContext context, BrainrotAdventure game) {
            return VictoryOverlay(game: _game);
          },
        },
      ),
    );
  }
}
