import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../pixel_adventure.dart';
import 'player.dart';

enum State { idle, run, hit }

class Turtle extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Turtle({
    super.position,
    super.size,
  });

  static const stepTime = 0.05;
  static const tileSize = 16;
  final textureSize = Vector2(44, 26);

  Vector2 velocity = Vector2.zero();
  double moveDirection = 1;
  double targetDirection = -1;
  bool gotStomped = false;

  late final Player player;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _hitAnimation;

  @override
  FutureOr<void> onLoad() {
    player = game.player;

    add(
      RectangleHitbox(
        position: Vector2(4, 6),
        size: Vector2(24, 26),
      ),
    );
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    _idleAnimation = _spriteAnimation('Idle 1', 14);
    _hitAnimation = _spriteAnimation('Hit', 15)..loop = false;

    animations = {
      State.idle: _idleAnimation,
      State.hit: _hitAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Turtle/$state (44x26).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
  }

  void collidedWithPlayer() async {
    player.collidedWithEnemy();
  }
}
