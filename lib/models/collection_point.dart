import 'package:flutter/material.dart';

enum PointStatus {
  completed,
  current,
  pending,
}

class CollectionPoint {
  final int id;
  final Offset position;
  final PointStatus status;
  final String? label;

  const CollectionPoint({
    required this.id,
    required this.position,
    required this.status,
    this.label,
  });
}

class RouteSegment {
  final List<Offset> points;
  final PointStatus status;

  const RouteSegment({
    required this.points,
    required this.status,
  });
}

class StreetLabel {
  final String name;
  final Offset position;
  final bool isVertical;

  const StreetLabel({
    required this.name,
    required this.position,
    this.isVertical = false,
  });
}

class PoiLabel {
  final String name;
  final Offset position;
  final bool isGreen;

  const PoiLabel({
    required this.name,
    required this.position,
    this.isGreen = false,
  });
}
