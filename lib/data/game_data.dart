import 'package:hive/hive.dart';

part 'game_data.g.dart';

@HiveType(typeId: 0)
class GameData extends HiveObject {
  @HiveField(0)
  List<int> completedLevels;

  @HiveField(1)
  Map<int, int> highScores; // levelNumber -> highScore

  GameData({required this.completedLevels, required this.highScores});
}

class GameDataBox {
  static const String boxName = 'game_data';

  static Future<Box<GameData>> openBox() async {
    return await Hive.openBox<GameData>(boxName);
  }
}
