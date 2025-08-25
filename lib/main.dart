import 'package:brainrot_adventure/data/game_data_manager.dart';
import 'package:brainrot_adventure/data/level_data_loader.dart';
import 'package:brainrot_adventure/data/setting_data.dart';
import 'package:brainrot_adventure/screen/game_screen.dart';
import 'package:brainrot_adventure/screen/level_selection_screen.dart';
import 'package:brainrot_adventure/screen/main_menu_screen.dart';
import 'package:brainrot_adventure/screen/setting_screen.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'data/game_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GameDataAdapter());
  Hive.registerAdapter(SettingsDataAdapter());
  await GameDataManager.init();
  await LevelDataLoader.loadLevels();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brainrot Adventure',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenuScreen(),
        '/level_select': (context) => const LevelSelectionScreen(),
        '/game': (context) => const GameScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
