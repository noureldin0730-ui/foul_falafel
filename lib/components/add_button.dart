import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../game/arabia_game.dart';

class AddCustomerButton extends PositionComponent with TapCallbacks {
  final ArabiaGame game;

  AddCustomerButton({
    required this.game,
    required Vector2 screenSize,
  }) : super(
          position: Vector2(30, screenSize.y - 90),
          size: Vector2(160, 60),
          priority: 200,
        );

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      Paint()..color = const Color(0xFFFFD54A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    final tp = TextPainter(
      text: const TextSpan(
        text: '+ زبون جديد',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    tp.paint(
      canvas,
      Offset((size.x - tp.width) / 2, (size.y - tp.height) / 2),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.addNewCustomer();
  }
}