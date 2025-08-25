import 'package:hive/hive.dart';

part 'setting_data.g.dart';

@HiveType(typeId: 1) // IMPORTANT: Use a different typeId than GameData
class SettingsData extends HiveObject {
  @HiveField(0)
  double bgmVolume;

  @HiveField(1)
  double sfxVolume;

  SettingsData({this.bgmVolume = 0.5, this.sfxVolume = 0.5});
}

class SettingDataBox {
  static const String boxName = 'settings_data';

  static Future<Box<SettingsData>> openBox() async {
    return await Hive.openBox<SettingsData>(boxName);
  }
}
