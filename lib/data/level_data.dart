class LevelData {
  final int levelNumber;
  final Map<String, int> objects;
  final List<String> maps;
  final int timeLimitInSeconds;
  final List<Map<String, String>> guideData;

  LevelData({
    required this.levelNumber,
    required this.objects,
    required this.maps,
    required this.timeLimitInSeconds,
    required this.guideData,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> objectsJson = json['objectsToCollect'];
    final Map<String, int> objects = objectsJson.map(
      (key, value) => MapEntry(key, value as int),
    );
    final List<dynamic> guideListJson = json['guide'];
    final List<Map<String, String>> guideData = guideListJson
        .map(
          (item) => {
            'title': item['title'] as String,
            'content': item['content'] as String,
          },
        )
        .toList();
    return LevelData(
      levelNumber: json['levelNumber'] as int,
      objects: objects,
      maps: List<String>.from(json['maps']),
      timeLimitInSeconds: json['timeLimitInSeconds'] as int,
      guideData: guideData,
    );
  }
}
