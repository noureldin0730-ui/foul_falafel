import 'dart:math' as math;

import 'package:flame/components.dart';
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

  void _buildWorld() {
    // 1. الزقاق بالكود
    add(AlleyBackground(size: size));

    // 2. العربية
    add(CartComponent(screenSize: size));

    // 3. HUD
    add(HudComponent(game: this));

    // 4. زرار زبون جديد
    add(AddCustomerButton(game: this, screenSize: size));
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

// ============================================================
// ALLEY BACKGROUND — الزقاق بالكود
// ============================================================
class AlleyBackground extends PositionComponent {
  AlleyBackground({required Vector2 size})
      : super(
          position: Vector2.zero(),
          size: size,
          priority: -100,
        );

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // 1. السماء
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF6BB8E8),
          Color(0xFFA8D8F0),
          Color(0xFFE8D8B0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.6));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.6), sky);

    // 2. شمس
    canvas.drawCircle(
      Offset(w * 0.85, h * 0.15),
      45,
      Paint()..color = const Color(0xFFFFF3B0).withOpacity(0.9),
    );
    canvas.drawCircle(
      Offset(w * 0.85, h * 0.15),
      60,
      Paint()
        ..color = const Color(0xFFFFF3B0).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    // 3. مباني الخلف
    _drawBuilding(canvas, w * 0.05, h * 0.25, w * 0.18, h * 0.35, const Color(0xFFE8D8C0));
    _drawBuilding(canvas, w * 0.20, h * 0.15, w * 0.15, h * 0.45, const Color(0xFFD8C8A8));
    _drawBuilding(canvas, w * 0.32, h * 0.30, w * 0.20, h * 0.30, const Color(0xFFE0D0B0));
    _drawBuilding(canvas, w * 0.50, h * 0.20, w * 0.18, h * 0.40, const Color(0xFFE8D8C0));
    _drawBuilding(canvas, w * 0.66, h * 0.28, w * 0.15, h * 0.32, const Color(0xFFD8C8A8));
    _drawBuilding(canvas, w * 0.80, h * 0.18, w * 0.18, h * 0.42, const Color(0xFFE0D0B0));

    // 4. الأرض
    final ground = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFD4B888),
          Color(0xFFB89868),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.6, w, h * 0.4));
    canvas.drawRect(Rect.fromLTWH(0, h * 0.6, w, h * 0.4), ground);

    // 5. خطوط الرصيف
    final linePaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..strokeWidth = 2;
    for (int i = 0; i < w; i += 60) {
      canvas.drawLine(
        Offset(i.toDouble(), h * 0.62),
        Offset(i + 30.0, h * 0.98),
        linePaint,
      );
    }

    // 6. تفاصيل الأرض
    final spotPaint = Paint()..color = Colors.black.withOpacity(0.08);
    for (int i = 0; i < 15; i++) {
      final x = (i * 137.5) % w;
      final y = h * 0.65 + ((i * 73.3) % (h * 0.3));
      canvas.drawCircle(Offset(x, y), 4 + (i % 3).toDouble(), spotPaint);
    }
  }

  void _drawBuilding(Canvas canvas, double x, double y, double w, double h, Color wallColor) {
    // جسم المبنى
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = wallColor,
    );

    // ظل على الجنب
    canvas.drawRect(
      Rect.fromLTWH(x + w - 8, y, 8, h),
      Paint()..color = Colors.black.withOpacity(0.15),
    );

    // شبابيك
    final windowPaint = Paint()..color = const Color(0xFF3A5A7A);
    final framePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final cols = (w / 40).floor();
    final rows = (h / 50).floor();

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        final wx = x + 10 + i * 40;
        final wy = y + 15 + j * 50;
        final windowRect = Rect.fromLTWH(wx, wy, 20, 25);

        canvas.drawRect(windowRect, windowPaint);
        canvas.drawRect(windowRect, framePaint);

        canvas.drawLine(
          Offset(wx + 10, wy),
          Offset(wx + 10, wy + 25),
          framePaint,
        );
      }
    }

    // سطح المبنى
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, 4),
      Paint()..color = Colors.black.withOpacity(0.2),
    );
  }
}