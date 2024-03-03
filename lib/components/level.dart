import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../pixel_adventure.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  final String levelName;

  Level({required this.levelName});
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    return super.onLoad();
  }
}
