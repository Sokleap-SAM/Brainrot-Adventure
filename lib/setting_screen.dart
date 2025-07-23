import 'package:flutter/material.dart';
import 'package:brainrot_adventure/levels/audio_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Settings'),
      //   backgroundColor: Colors.blue.shade700,
      //   foregroundColor: Colors.white,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       AudioManager.instance.resumeBgm();
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background/game.png'),
            fit: BoxFit.cover,
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
                          width: 100, // Explicitly sets the width
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
                            value: 0.7,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: 'Volume: ',
                            onChanged: (double value) {
                              print('Music Volume changed: $value');
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
                          width: 100, // Explicitly sets the width
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
                            value: 0.7,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: 'Volume:',
                            onChanged: (double value) {
                              print('SFX Volume changed: $value');
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
                  AudioManager.instance.pauseBgm();
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
