import 'package:flame/components.dart';
import 'package:flutter/material.dart';

const int tileSize = 32;

Offset worldToGridOffset(Vector2 mapLocation) {
  double x = (mapLocation.x / tileSize).floor().toDouble();
  double y = (mapLocation.y / tileSize).floor().toDouble();

  return Offset(x, y);
}

Vector2 gridOffsetToWorld(Offset gridOffset) {
  double x = (gridOffset.dx * tileSize);
  double y = (gridOffset.dy * tileSize);

  return Vector2(x, y);
}
