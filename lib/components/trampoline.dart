import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';

import '../pixel_adventure.dart';
import 'player.dart';

enum State { idle, jump }

class Trampoline extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  static const stepTime = 0.05;
  static const tileSize = 16;
  static const _bounceHeight = 300.0;
  final textureSize = Vector2(28, 28);

  late final Player player;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _jumpAnimation;

  Trampoline({
    super.position,
    super.size,
  });

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
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
    _idleAnimation = _spriteAnimation('Idle', 1);
    _jumpAnimation = _spriteAnimation('Jump', 8);

    animations = {
      State.idle: _idleAnimation,
      State.jump: _jumpAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Trampoline/$state (28x28).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
  }

  void collidedWithPlayer() async {
    if (game.playSounds) {
      FlameAudio.play('bounce.wav', volume: game.soundVolume);
    }
    debugPrint("[collidedWithPlayer] Before: $current");
    current = State.jump;
    debugPrint("[collidedWithPlayer - velocity] Before: ${player.velocity.y}");
    player.setJumpForce(_bounceHeight);
    player.velocity.y = -_bounceHeight;
    debugPrint(
        "[collidedWithPlayer - velocity] After: ${player.velocity.y}, bounce height: ${_bounceHeight}");
    //player.setJumpForce(260);
    await animationTicker?.completed;
    current = State.idle;
    debugPrint("[collidedWithPlayer] After: $current");
  }
}
