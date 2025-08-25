class LevelData {
  final int levelNumber;
  final Map<String, int> objects;
  final List<String> maps;
  final int timeLimitInSeconds;

  LevelData({
    required this.levelNumber,
    required this.objects,
    required this.maps,
    required this.timeLimitInSeconds,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> objectsJson = json['objectsToCollect'];
    final Map<String, int> objects = objectsJson.map(
      (key, value) => MapEntry(key, value as int),
    );
    return LevelData(
      levelNumber: json['levelNumber'] as int,
      objects: objects,
      maps: List<String>.from(json['maps']),
      timeLimitInSeconds: json['timeLimitInSeconds'] as int,
    );
  }
}
