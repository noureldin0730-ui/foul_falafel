import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/arabia_game.dart';

class HudComponent extends PositionComponent {
  final ArabiaGame game;

  HudComponent({required this.game})
      : super(
          position: Vector2.zero(),
          size: Vector2(500, 60),
          priority: 999,
        );

  @override
  void render(Canvas canvas) {
    _drawChip(canvas, Vector2(0, 0), '💰 ${game.money}', const Color(0xFFFFD54A));
    _drawChip(canvas, Vector2(140, 0), '👥 ${game.customersServed}', const Color(0xFF7AD77A));
    _drawChip(canvas, Vector2(280, 0), 'Foul & Falafel', const Color(0xFF7AD7FF));
  }

  void _drawChip(Canvas canvas, Vector2 offset, String text, Color color) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(offset.x, offset.y, 130, 44),
      const Radius.circular(8),
    );

    canvas.drawRRect(rect, Paint()..color = Colors.black.withOpacity(0.6));
    canvas.drawRRect(
      rect,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    tp.paint(
      canvas,
      Offset(offset.x + (130 - tp.width) / 2, offset.y + (44 - tp.height) / 2),
    );
  }
}