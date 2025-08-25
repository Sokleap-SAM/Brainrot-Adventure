import 'package:brainrot_adventure/data/setting_data.dart';
import 'package:hive/hive.dart';
import 'package:brainrot_adventure/data/game_data.dart';

class GameDataManager {
  static late Box<GameData> _gameDataBox;
  static late Box<SettingsData> _settingsBox;
  static const String _progressKey = 'progress';
  static const String _settingsKey = 'settings';

  static Future<void> init() async {
    _gameDataBox = await Hive.openBox<GameData>(GameDataBox.boxName);
    _settingsBox = await Hive.openBox<SettingsData>(SettingDataBox.boxName);

    if (!_gameDataBox.containsKey(_progressKey)) {
      final Map<int, int> initialHighScores = {};
      for (int i = 1; i <= 27; i++) {
        initialHighScores[i] = 0;
      }

      await _gameDataBox.put(
        _progressKey,
        GameData(completedLevels: [], highScores: initialHighScores),
      );

      if (!_settingsBox.containsKey(_settingsKey)) {
        await _settingsBox.put(_settingsKey, SettingsData());
      }
    }
  }

  static Future<void> saveGameProgress(int newLevel, int newScore) async {
    final gameData = _gameDataBox.get(_progressKey)!;

    if (!gameData.completedLevels.contains(newLevel)) {
      gameData.completedLevels.add(newLevel);
    }

    if (gameData.highScores[newLevel] == null ||
        newScore > gameData.highScores[newLevel]!) {
      gameData.highScores[newLevel] = newScore;
    }

    await _gameDataBox.put(_progressKey, gameData);
  }

  static GameData? loadGameProgress() {
    return _gameDataBox.get(_progressKey);
  }

  static int getHighScoreForLevel(int level) {
    final gameData = _gameDataBox.get(_progressKey);
    return gameData?.highScores[level] ?? 0;
  }

  static Future<void> saveSettings({
    double? bgmVolume,
    double? sfxVolume,
  }) async {
    final settings = _settingsBox.get(_settingsKey) ?? SettingsData();
    if (bgmVolume != null) {
      settings.bgmVolume = bgmVolume;
    }
    if (sfxVolume != null) {
      settings.sfxVolume = sfxVolume;
    }
    await _settingsBox.put(_settingsKey, settings);
  }

  static SettingsData getSettings() {
    return _settingsBox.get(_settingsKey) ?? SettingsData();
  }
}
