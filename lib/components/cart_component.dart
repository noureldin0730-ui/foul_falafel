import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class CartComponent extends PositionComponent {
  Sprite? _sprite;

  CartComponent({required Vector2 screenSize})
      : super(
          size: Vector2(220, 260),
          priority: 100,
        ) {
    position = Vector2(
      screenSize.x / 2 - 110,
      screenSize.y - 280,
    );
  }

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('images/arabia/cart.png');
    _sprite = Sprite(image);
  }

  @override
  void render(Canvas canvas) {
    if (_sprite == null) return;
    _sprite!.render(
      canvas,
      position: Vector2.zero(),
      size: size,
    );
  }
}