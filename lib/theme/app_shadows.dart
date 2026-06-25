import 'package:flutter/material.dart';

class AppShadows {
  const AppShadows._();

  static const card = [
    BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 10)),
  ];

  static const elevated = [
    BoxShadow(color: Color(0x66000000), blurRadius: 28, offset: Offset(0, 16)),
  ];
}
