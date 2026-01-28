import 'package:flutter/material.dart';
import '../models/collection_point.dart';

class CollectionPointMarker extends StatelessWidget {
  final CollectionPoint point;
  final double size;

  const CollectionPointMarker({
    super.key,
    required this.point,
    this.size = 26,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(),
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: _buildContent(),
      ),
    );
  }

  List<Color> _getGradientColors() {
    switch (point.status) {
      case PointStatus.completed:
        return [const Color(0xFF6B7280), const Color(0xFF4B5563)];
      case PointStatus.current:
        return [const Color(0xFFF59E0B), const Color(0xFFD97706)];
      case PointStatus.pending:
        return [const Color(0xFF22C55E), const Color(0xFF16A34A)];
    }
  }

  Color _getShadowColor() {
    switch (point.status) {
      case PointStatus.completed:
        return const Color(0xFF6B7280).withOpacity(0.4);
      case PointStatus.current:
        return const Color(0xFFF59E0B).withOpacity(0.6);
      case PointStatus.pending:
        return const Color(0xFF22C55E).withOpacity(0.5);
    }
  }

  Widget _buildContent() {
    switch (point.status) {
      case PointStatus.completed:
        return const Icon(
          Icons.check,
          color: Colors.white,
          size: 14,
        );
      case PointStatus.current:
        return Text(
          point.label ?? '!',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        );
      case PointStatus.pending:
        return Text(
          point.label ?? point.id.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        );
    }
  }
}

class AnimatedCollectionPointMarker extends StatefulWidget {
  final CollectionPoint point;
  final double size;

  const AnimatedCollectionPointMarker({
    super.key,
    required this.point,
    this.size = 30,
  });

  @override
  State<AnimatedCollectionPointMarker> createState() =>
      _AnimatedCollectionPointMarkerState();
}

class _AnimatedCollectionPointMarkerState
    extends State<AnimatedCollectionPointMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: -4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.point.status != PointStatus.current) {
      return CollectionPointMarker(point: widget.point, size: widget.size);
    }

    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: CollectionPointMarker(point: widget.point, size: widget.size),
        );
      },
    );
  }
}
