import 'package:flame_audio/flame_audio.dart';
import 'dart:async';

class AudioManager {
  AudioManager._internal();

  static final AudioManager _instance = AudioManager._internal();

  static AudioManager get instance => _instance;

  late double musicVolume;
  late double sfxVolume;
  final Map<String, AudioPool> _sfxPools = {};

  Future<void> init(List<String> files) async {
    FlameAudio.bgm.initialize();
    for (String file in files) {
      if (file.endsWith('.wav')) {
        _sfxPools[file] = await FlameAudio.createPool(
          file,
          minPlayers: 1,
          maxPlayers: 3,
        );
      }
    }
    await FlameAudio.audioCache.load('Pixel Daydream.mp3');
  }

  void setMusicVolume(double volume) {
    musicVolume = volume;
  }

  void setSFXVolume(double volume) {
    sfxVolume = volume;
  }

  void startBgm(String fileName) {
    FlameAudio.bgm.play(fileName, volume: musicVolume);
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  void resumeBgm() {
    FlameAudio.bgm.resume();
  }

  void playSfx(String fileName) {
    if (_sfxPools.containsKey(fileName)) {
      _sfxPools[fileName]!.start(volume: sfxVolume);
    } else {
      FlameAudio.play(fileName, volume: sfxVolume);
    }
  }

  void dispose() {
    for (var pool in _sfxPools.values) {
      pool.dispose();
    }
    _sfxPools.clear();
  }
}
