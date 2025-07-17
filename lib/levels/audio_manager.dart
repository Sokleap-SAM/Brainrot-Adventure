import 'package:flame_audio/flame_audio.dart'; // Import AudioPlayer for the pool type
import 'dart:async';

class AudioManager {
  final Map<String, AudioPool> _sfxPools = {}; // Now stores AudioPools

  Future<void> init(List<String> files) async {
    FlameAudio.bgm.initialize();
    for (String file in files) {
      if (file.endsWith('.wav')) {
        // Only create pools for SFX files
        _sfxPools[file] = await FlameAudio.createPool(
          file,
          minPlayers: 1,
          maxPlayers: 3,
        );
      }
    }
    await FlameAudio.audioCache.load(
      'Pixel Daydream.mp3',
    ); // Ensure BGM is cached
  }

  void startBgm(String fileName, volume) {
    FlameAudio.bgm.play(fileName, volume: volume);
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  void pauseBgm() {
    FlameAudio.bgm.pause();
    print('pause');
  }

  void resumeBgm() {
    FlameAudio.bgm.resume();
    print('resume');
  }

  // ... startBgm, stopBgm, pauseBgm, resumeBgm ...

  void playSfx(String fileName, double volume) {
    if (_sfxPools.containsKey(fileName)) {
      // It's possible to set volume on the pool, but individual players are usually more precise.
      // For now, FlameAudio.createPool doesn't directly expose a pool-wide volume setter that applies to players on play().
      // You'd typically set the volume on the Player instance before it plays.
      // However, FlameAudio.play from pool is simpler.
      _sfxPools[fileName]!.start(
        volume: volume,
      ); // Using the play method with volume parameter
    } else {
      FlameAudio.play(fileName, volume: volume); // Fallback
    }
  }

  void dispose() {
    for (var pool in _sfxPools.values) {
      pool.dispose();
    }
    _sfxPools.clear();
  }
}
