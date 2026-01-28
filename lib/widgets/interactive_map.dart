import 'package:flutter/material.dart';
import '../models/collection_point.dart';
import '../theme/app_theme.dart';
import 'map_painter.dart';
import 'collection_point_marker.dart';
import 'truck_marker.dart';
import 'location_marker.dart';

class InteractiveMap extends StatefulWidget {
  final List<CollectionPoint> collectionPoints;
  final List<RouteSegment> routes;
  final Offset? truckPosition;
  final Offset? userPosition;
  final List<StreetLabel> streetLabels;
  final List<PoiLabel> poiLabels;
  final double height;

  const InteractiveMap({
    super.key,
    required this.collectionPoints,
    required this.routes,
    this.truckPosition,
    this.userPosition,
    this.streetLabels = const [],
    this.poiLabels = const [],
    this.height = 340,
  });

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.mapBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Map background and routes
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: MapPainter(
                    routes: widget.routes,
                    animationValue: _animationController.value,
                  ),
                );
              },
            ),

            // Street labels
            ...widget.streetLabels.map((label) => _buildStreetLabel(label)),

            // POI labels
            ...widget.poiLabels.map((poi) => _buildPoiLabel(poi)),

            // Collection points
            ...widget.collectionPoints.map((point) => _buildCollectionPoint(point)),

            // User location
            if (widget.userPosition != null)
              Positioned(
                left: widget.userPosition!.dx * _getMapWidth(context) - 24,
                top: widget.userPosition!.dy * widget.height - 24,
                child: const LocationMarker(),
              ),

            // Truck
            if (widget.truckPosition != null)
              Positioned(
                left: widget.truckPosition!.dx * _getMapWidth(context) - 20,
                top: widget.truckPosition!.dy * widget.height - 20,
                child: const TruckMarker(),
              ),

            // Map controls
            Positioned(
              right: 12,
              top: widget.height / 2 - 52,
              child: _buildMapControls(),
            ),
          ],
        ),
      ),
    );
  }

  double _getMapWidth(BuildContext context) {
    return MediaQuery.of(context).size.width - 32;
  }

  Widget _buildStreetLabel(StreetLabel label) {
    return Positioned(
      left: label.position.dx * _getMapWidth(context),
      top: label.position.dy * widget.height,
      child: Transform.rotate(
        angle: label.isVertical ? 1.5708 : 0,
        child: Text(
          label.name,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPoiLabel(PoiLabel poi) {
    return Positioned(
      left: poi.position.dx * _getMapWidth(context),
      top: poi.position.dy * widget.height,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: poi.isGreen
              ? AppTheme.routeCompleted.withOpacity(0.9)
              : Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          poi.name,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: poi.isGreen ? Colors.white : const Color(0xFF333333),
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionPoint(CollectionPoint point) {
    final mapWidth = MediaQuery.of(context).size.width - 32;
    final markerSize = point.status == PointStatus.current ? 30.0 : 26.0;

    return Positioned(
      left: point.position.dx * mapWidth - markerSize / 2,
      top: point.position.dy * widget.height - markerSize / 2,
      child: point.status == PointStatus.current
          ? AnimatedCollectionPointMarker(point: point, size: markerSize)
          : CollectionPointMarker(point: point, size: markerSize),
    );
  }

  Widget _buildMapControls() {
    return Column(
      children: [
        _buildControlButton(Icons.my_location, () {}),
        const SizedBox(height: 4),
        _buildControlButton(Icons.add, () {}),
        const SizedBox(height: 4),
        _buildControlButton(Icons.remove, () {}),
      ],
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: const Color(0xFF374151),
        ),
      ),
    );
  }
}
