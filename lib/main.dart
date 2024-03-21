import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/hud.dart';
import 'components/victory_screen.dart';
import 'pixel_adventure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const PixelAdventureApp());
}

class PixelAdventureApp extends StatelessWidget {
  const PixelAdventureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dino Run',
      theme: ThemeData(
        fontFamily: 'Audiowide',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Settings up some default theme for elevated buttons.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            fixedSize: const Size(200, 60),
          ),
        ),
      ),
      home: Scaffold(
        body: GameWidget<PixelAdventure>.controlled(
          // This will display a loading bar until [DinoRun] completes
          // its onLoad method.
          loadingBuilder: (context) => const Center(
            child: SizedBox(
              width: 200,
              child: LinearProgressIndicator(),
            ),
          ),
          // Register all the overlays that will be used by this game.
          overlayBuilderMap: {
            Hud.id: (_, game) => Hud(game),
            VictoryScreen.id: (_, game) => VictoryScreen(game),
          },

          gameFactory: () => PixelAdventure(),
        ),
      ),
    );
  }
}
