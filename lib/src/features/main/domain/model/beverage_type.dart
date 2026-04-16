import 'package:flutter/material.dart';

enum BeverageType {
  water,
  coffee,
  tea,
  juice,
  soda,
  milk,
}

extension BeverageTypeX on BeverageType {
  String get id => name;

  String get label => switch (this) {
    BeverageType.water => '물',
    BeverageType.coffee => '커피',
    BeverageType.tea => '차',
    BeverageType.juice => '주스',
    BeverageType.soda => '탄산',
    BeverageType.milk => '우유',
  };

  String get assetPath => 'assets/$id.png';

  /// 에셋이 없을 때를 위한 아이콘.
  IconData get icon => switch (this) {
    BeverageType.water => Icons.water_drop_outlined,
    BeverageType.coffee => Icons.coffee_outlined,
    BeverageType.tea => Icons.emoji_food_beverage_outlined,
    BeverageType.juice => Icons.local_drink_outlined,
    BeverageType.soda => Icons.sports_bar_outlined,
    BeverageType.milk => Icons.local_cafe_outlined,
  };

  Color get color => switch (this) {
    BeverageType.water => const Color(0xFF2D7FF9),
    BeverageType.coffee => const Color(0xFF8B5A2B),
    BeverageType.tea => const Color(0xFF3F8F5B),
    BeverageType.juice => const Color(0xFF2DBE60),
    BeverageType.soda => const Color(0xFFFF7A00),
    BeverageType.milk => const Color(0xFFA0A8B3),
  };
}

