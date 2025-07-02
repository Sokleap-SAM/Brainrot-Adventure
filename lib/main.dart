import 'package:brainrot_adventure/test_adventure.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  TestAdventure game = TestAdventure();
  runApp(GameWidget(game: kDebugMode ? TestAdventure() : game));
}
