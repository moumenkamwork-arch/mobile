import 'package:flutter/material.dart';

class AppRadius {
  const AppRadius._();

  static const xs = 6.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const full = 999.0;

  static const card = BorderRadius.all(Radius.circular(lg));
  static const input = BorderRadius.all(Radius.circular(md));
  static const button = BorderRadius.all(Radius.circular(lg));
  static const pill = BorderRadius.all(Radius.circular(full));
  static const bottomNav = BorderRadius.all(Radius.circular(xl));
  static const sheet = BorderRadiusDirectional.vertical(
    top: Radius.circular(xl),
  );
}
