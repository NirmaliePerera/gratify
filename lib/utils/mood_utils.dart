import 'package:flutter/material.dart';

Color colorForValue(double value) {
  if (value < 20) return Colors.red;
  if (value < 40) return const Color.fromARGB(255, 225, 255, 0);
  if (value < 60) return const Color.fromARGB(255, 61, 241, 127);
  if (value < 80) return const Color.fromARGB(255, 86, 106, 255);
  return const Color.fromARGB(255, 235, 65, 254);
}
