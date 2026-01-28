import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/collection_point.dart';
import '../theme/app_theme.dart';

class MapPainter extends CustomPainter {
  final List<RouteSegment> routes;
  final double animationValue;

  MapPainter({
    required this.routes,
    this.animationValue = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBlocks(canvas, size);
    _drawStreets(canvas, size);
    _drawRoutes(canvas, size);
  }

  void _drawBlocks(Canvas canvas, Size size) {
    final blockPaint = Paint()..style = PaintingStyle.fill;
    
    final blocks = [
      // Row 1
      const _Block(0.05, 0.05, 0.22, 0.15, AppTheme.mapBlock),
      const _Block(0.30, 0.05, 0.28, 0.15, AppTheme.mapGreen),
      const _Block(0.62, 0.05, 0.33, 0.15, AppTheme.mapBlock),
      // Row 2
      const _Block(0.05, 0.28, 0.22, 0.20, AppTheme.mapGreen),
      const _Block(0.30, 0.28, 0.28, 0.20, AppTheme.mapBlock),
      const _Block(0.62, 0.28, 0.33, 0.20, AppTheme.mapBlock),
      // Row 3
      const _Block(0.05, 0.56, 0.22, 0.18, AppTheme.mapBlock),
      const _Block(0.30, 0.56, 0.28, 0.18, AppTheme.mapBlock),
      const _Block(0.62, 0.56, 0.33, 0.18, AppTheme.mapGreen),
      // Row 4
      const _Block(0.05, 0.82, 0.22, 0.13, AppTheme.mapBlock),
      const _Block(0.30, 0.82, 0.28, 0.13, AppTheme.mapGreen),
      const _Block(0.62, 0.82, 0.33, 0.13, AppTheme.mapBlock),
    ];

    for (final block in blocks) {
      blockPaint.color = block.color;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            block.x * size.width,
            block.y * size.height,
            block.width * size.width,
            block.height * size.height,
          ),
          const Radius.circular(4),
        ),
        blockPaint,
      );
    }
  }

  void _drawStreets(Canvas canvas, Size size) {
    final streetPaint = Paint()
      ..color = AppTheme.mapStreet
      ..style = PaintingStyle.fill;

    final centerLinePaint = Paint()
      ..color = const Color(0xFFE5E5E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Horizontal streets
    final hStreets = [0.23, 0.52, 0.78];
    for (final y in hStreets) {
      canvas.drawRect(
        Rect.fromLTWH(0, y * size.height, size.width, size.height * 0.035),
        streetPaint,
      );
      // Center line
      canvas.drawLine(
        Offset(0, (y + 0.0175) * size.height),
        Offset(size.width, (y + 0.0175) * size.height),
        centerLinePaint..strokeWidth = 1,
      );
    }

    // Vertical streets
    final vStreets = [0.27, 0.595];
    for (final x in vStreets) {
      canvas.drawRect(
        Rect.fromLTWH(x * size.width, 0, size.width * 0.035, size.height),
        streetPaint,
      );
      // Center line
      canvas.drawLine(
        Offset((x + 0.0175) * size.width, 0),
        Offset((x + 0.0175) * size.width, size.height),
        centerLinePaint,
      );
    }
  }

  void _drawRoutes(Canvas canvas, Size size) {
    for (final route in routes) {
      if (route.points.length < 2) continue;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      switch (route.status) {
        case PointStatus.completed:
          paint.color = AppTheme.routeCompleted;
          break;
        case PointStatus.current:
          paint.color = AppTheme.routeCurrent;
          // Animated dash effect
          paint.strokeWidth = 5;
          break;
        case PointStatus.pending:
          paint.color = AppTheme.routePending.withOpacity(0.6);
          paint.strokeWidth = 4;
          break;
      }

      final path = Path();
      path.moveTo(
        route.points.first.dx * size.width,
        route.points.first.dy * size.height,
      );

      for (int i = 1; i < route.points.length; i++) {
        path.lineTo(
          route.points[i].dx * size.width,
          route.points[i].dy * size.height,
        );
      }

      if (route.status == PointStatus.pending) {
        _drawDashedPath(canvas, path, paint, [8, 6]);
      } else if (route.status == PointStatus.current) {
        _drawAnimatedDashedPath(canvas, path, paint, [12, 8]);
      } else {
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, List<double> pattern) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      bool draw = true;
      int patternIndex = 0;
      
      while (distance < metric.length) {
        final length = pattern[patternIndex % pattern.length];
        final nextDistance = math.min(distance + length, metric.length);
        
        if (draw) {
          final extractPath = metric.extractPath(distance, nextDistance);
          canvas.drawPath(extractPath, paint);
        }
        
        distance = nextDistance;
        draw = !draw;
        patternIndex++;
      }
    }
  }

  void _drawAnimatedDashedPath(Canvas canvas, Path path, Paint paint, List<double> pattern) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = animationValue * (pattern[0] + pattern[1]);
      bool draw = true;
      int patternIndex = 0;
      
      while (distance < metric.length) {
        final length = pattern[patternIndex % pattern.length];
        final nextDistance = math.min(distance + length, metric.length);
        
        if (draw && distance >= 0) {
          final extractPath = metric.extractPath(
            math.max(0, distance),
            nextDistance,
          );
          canvas.drawPath(extractPath, paint);
        }
        
        distance = nextDistance;
        draw = !draw;
        patternIndex++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class _Block {
  final double x, y, width, height;
  final Color color;
  
  const _Block(this.x, this.y, this.width, this.height, this.color);
}
