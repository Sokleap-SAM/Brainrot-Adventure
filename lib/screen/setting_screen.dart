import 'package:brainrot_adventure/data/game_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:brainrot_adventure/components/audio_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _currentMusicVolume;
  late double _currentSfxVolume;

  @override
  void initState() {
    super.initState();
    final settings = GameDataManager.getSettings();
    _currentMusicVolume = settings.bgmVolume;
    _currentSfxVolume = settings.sfxVolume;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AudioManager.instance.resumeBgm();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background/game.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Settings',
                style: TextStyle(
                  fontSize: 48.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Music:',
                            style: const TextStyle(
                              fontSize: 28.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _currentMusicVolume,
                            min: 0.0,
                            max: 1.0,
                            divisions: 50,
                            label: _currentMusicVolume.toStringAsFixed(2),
                            onChanged: (double value) {
                              setState(() {
                                _currentMusicVolume = value;
                                GameDataManager.saveSettings(bgmVolume: value);
                                AudioManager.instance.setMusicVolume(value);
                              });
                            },
                            activeColor: Colors.blue,
                            inactiveColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            'SFX:',
                            style: const TextStyle(
                              fontSize: 28.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _currentSfxVolume,
                            min: 0.0,
                            max: 1.0,
                            divisions: 50,
                            label: _currentSfxVolume.toStringAsFixed(2),
                            onChanged: (double value) {
                              setState(() {
                                _currentSfxVolume = value;
                                GameDataManager.saveSettings(sfxVolume: value);
                                AudioManager.instance.setSFXVolume(value);
                              });
                            },
                            activeColor: Colors.blue,
                            inactiveColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                  elevation: 10,
                ),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
