import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../components/add_button.dart';
import '../components/cart_component.dart';
import '../components/customer_component.dart';
import '../components/hud.dart';

class ArabiaGame extends FlameGame {
  int customersServed = 0;
  int money = 0;
  final List<CustomerComponent> _activeCustomers = [];

  bool _worldBuilt = false;

  @override
  Color backgroundColor() => const Color(0xFF2A1F14);

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    if (_worldBuilt) return;
    if (newSize.x < 10 || newSize.y < 10) return;
    _worldBuilt = true;
    _buildWorld();
  }

  Future<void> _buildWorld() async {
    try {
      final bgImage = await Flame.images.load(
        'images/arabia/street_bg.png',
      );
      add(SpriteComponent(
        sprite: Sprite(bgImage),
        size: size,
        priority: -100,
      ));

      add(CartComponent(screenSize: size));
      add(HudComponent(game: this));
      add(AddCustomerButton(game: this, screenSize: size));
    } catch (e) {
      add(ErrorComponent(message: e.toString()));
    }
  }

  void addNewCustomer() {
    if (_activeCustomers.length >= 4) return;
    final variant = (_activeCustomers.length % 4) + 1;
    final c = CustomerComponent(
      game: this,
      variant: variant,
      slotIndex: _activeCustomers.length,
      screenSize: size,
    );
    _activeCustomers.add(c);
    add(c);
  }

  void serveCustomer(CustomerComponent c) {
    customersServed++;
    money += c.order.price;
    c.removeFromParent();
    _activeCustomers.remove(c);
  }
}

class ErrorComponent extends PositionComponent {
  final String message;

  ErrorComponent({required this.message})
      : super(
          position: Vector2(20, 100),
          size: Vector2(700, 250),
          priority: 9999,
        );

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(10),
      ),
      Paint()..color = Colors.red.withOpacity(0.9),
    );

    final tp = TextPainter(
      text: TextSpan(
        text: message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.x - 20);

    tp.paint(canvas, const Offset(10, 10));
  }
}