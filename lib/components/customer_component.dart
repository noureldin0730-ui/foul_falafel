import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../data/order_data.dart';
import '../game/arabia_game.dart';

class CustomerComponent extends PositionComponent with TapCallbacks {
  final ArabiaGame game;
  final int variant;
  final int slotIndex;

  late OrderItem order;

  Sprite? _sprite;
  Sprite? _foodSprite;
  double _bob = 0;

  CustomerComponent({
    required this.game,
    required this.variant,
    required this.slotIndex,
    required Vector2 screenSize,
  }) : super(
          size: Vector2(140, 240),
          priority: 50 + slotIndex,
        ) {
    const startX = 280.0;
    const spacing = 130.0;
    position = Vector2(
      startX + (slotIndex * spacing),
      screenSize.y - 380,
    );
  }

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load(
      'assets/images/arabia/customer_$variant.png',
    );
    _sprite = Sprite(image);

    order = OrderData.random();

    try {
      final foodImg = await Flame.images.load(
        'assets/images/arabia/${order.imageName}',
      );
      _foodSprite = Sprite(foodImg);
    } catch (e) {
      debugPrint('>>> Food image failed: ${order.imageName} - $e');
    }
  }

  @override
  void update(double dt) {
    _bob += dt * 2.5;
  }

  @override
  void render(Canvas canvas) {
    if (_sprite == null) return;

    final offsetY = math.sin(_bob) * 4;

    _sprite!.render(canvas, position: Vector2(0, offsetY), size: size);
    _drawExclamation(canvas, size.x / 2, -10 + offsetY);
    _drawOrderBubble(canvas, size.x / 2, -70 + offsetY);
  }

  void _drawExclamation(Canvas canvas, double x, double y) {
    final bob = math.sin(_bob * 2) * 3;
    final cy = y + bob;

    canvas.drawCircle(
      Offset(x, cy),
      14,
      Paint()..color = const Color(0xFFFFD54A),
    );
    canvas.drawCircle(
      Offset(x, cy),
      14,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final tp = TextPainter(
      text: const TextSpan(
        text: '!',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, cy - tp.height / 2));
  }

  void _drawOrderBubble(Canvas canvas, double x, double y) {
    if (_foodSprite == null) return;

    const bubbleW = 110.0;
    const bubbleH = 95.0;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x - bubbleW / 2, y - bubbleH / 2, bubbleW, bubbleH),
      const Radius.circular(10),
    );

    canvas.drawRRect(rect, Paint()..color = Colors.white.withOpacity(0.95));
    canvas.drawRRect(
      rect,
      Paint()
        ..color = order.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    _foodSprite!.render(
      canvas,
      position: Vector2(x - 28, y - 38),
      size: Vector2(56, 42),
    );

    final tp = TextPainter(
      text: TextSpan(
        text: order.nameAr,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout(maxWidth: bubbleW - 10);

    tp.paint(canvas, Offset(x - tp.width / 2, y + 8));
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.serveCustomer(this);
  }
}