import 'package:flame_audio/flame_audio.dart';
import 'dart:async';

class AudioManager {
  AudioManager._internal();

  static final AudioManager _instance = AudioManager._internal();

  static AudioManager get instance => _instance;

  double musicVolume = 0.5;
  double sfxVolume = 0.5;
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

  void startBgm(String fileName, volume) {
    FlameAudio.bgm.play(fileName, volume: volume);
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

  void playSfx(String fileName, double volume) {
    if (_sfxPools.containsKey(fileName)) {
      _sfxPools[fileName]!.start(volume: volume);
    } else {
      FlameAudio.play(fileName, volume: volume);
    }
  }

  void dispose() {
    for (var pool in _sfxPools.values) {
      pool.dispose();
    }
    _sfxPools.clear();
  }
}
