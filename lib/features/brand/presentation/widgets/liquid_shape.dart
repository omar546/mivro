import 'package:flutter/material.dart';

Widget liquidShape(BuildContext context, Color color, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(size), // makes it circular
    ),
  );
}
