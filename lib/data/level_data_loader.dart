import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:brainrot_adventure/data/level_data.dart';

class LevelDataLoader {
  static late List<LevelData> _levels;
  static bool _isLoaded = false;

  static Future<void> loadLevels() async {
    if (_isLoaded) return;
    final jsonString = await rootBundle.loadString('assets/levels.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    _levels = jsonList.map((json) => LevelData.fromJson(json)).toList();
    _isLoaded = true;
  }

  static LevelData getLevelData(int levelNumber) {
    if (!_isLoaded) {
      throw Exception('Level data not loaded. Call loadLevels() first.');
    }
    try {
      return _levels.firstWhere((level) => level.levelNumber == levelNumber);
    } catch (e) {
      throw Exception('Level $levelNumber not found in loaded data.');
    }
  }
}
