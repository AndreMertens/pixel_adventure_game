import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/victory_screen.dart';

import 'components/hud.dart';
import 'components/level.dart';
import 'components/player.dart';
import 'components/player_data.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  PlayerData playerData = PlayerData();
  Player player = Player(character: 'Mask Dude');

  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelNames = [
    'Level-01',
    'Level-02',
    'Level-03',
    'Level-04',
    'Level-05',
    'Level-06',
  ];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    _loadLevel();

    return super.onLoad();
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      overlays.add(VictoryScreen.id);
      overlays.remove(Hud.id);
      pauseEngine();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 736,
        height: 464,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
      overlays.add(Hud.id);
    });
  }
}
