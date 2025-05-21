import 'package:flame/components.dart';
import 'package:flutter/material.dart';

const int tileSize = 32;

Offset worldToGridOffset(Vector2 mapLocation) {
  double x = (mapLocation.x / tileSize).floor().toDouble();
  double y = (mapLocation.y / tileSize).floor().toDouble();

  return Offset(x, y);
}

(int, int) worldToGridIntTuple(Vector2 mapLocation) {
  double x = (mapLocation.x / tileSize).floor().toDouble();
  double y = (mapLocation.y / tileSize).floor().toDouble();

  return (x.toInt(), y.toInt());
}

Vector2 gridIntTupleToWorld((int, int) gridIntTuple) {
  double x = (gridIntTuple.$1.toDouble() * tileSize);
  double y = (gridIntTuple.$2.toDouble() * tileSize);

  return Vector2(x, y);
}
