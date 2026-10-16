import 'package:flutter/material.dart';

class OrderItem {
  final String nameAr;
  final String imageName;
  final int price;
  final Color color;

  const OrderItem({
    required this.nameAr,
    required this.imageName,
    required this.price,
    required this.color,
  });
}

class OrderData {
  static const List<OrderItem> all = [
    OrderItem(
      nameAr: 'كبدة سادة',
      imageName: 'kebda.png',
      price: 15,
      color: Color(0xFF8B4513),
    ),
    OrderItem(
      nameAr: 'فول بزيت',
      imageName: 'foul.png',
      price: 10,
      color: Color(0xFFA0522D),
    ),
    OrderItem(
      nameAr: 'طعمية 6 حبات',
      imageName: 'falafel.png',
      price: 8,
      color: Color(0xFFDAA520),
    ),
    OrderItem(
      nameAr: 'بطاطس كبير',
      imageName: 'fries.png',
      price: 12,
      color: Color(0xFFFF6347),
    ),
    OrderItem(
      nameAr: 'ساندوتش كبدة',
      imageName: 'kebda.png',
      price: 20,
      color: Color(0xFF8B4513),
    ),
    OrderItem(
      nameAr: 'عيش بلدي',
      imageName: 'bread.png',
      price: 5,
      color: Color(0xFFDEB887),
    ),
    OrderItem(
      nameAr: 'مخلل',
      imageName: 'pickles.png',
      price: 6,
      color: Color(0xFF6B8E23),
    ),
    OrderItem(
      nameAr: 'سبيرو سباتس',
      imageName: 'soda.png',
      price: 7,
      color: Color(0xFFDC143C),
    ),
  ];

  static OrderItem random() {
    return all[(DateTime.now().microsecond) % all.length];
  }

  static String fullImagePath(String imageName) {
    return 'assets/images/arabia/$imageName';
  }
}