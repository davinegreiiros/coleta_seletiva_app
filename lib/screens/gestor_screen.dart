import 'package:flutter/material.dart';
import '../models/collection_point.dart';
import '../theme/app_theme.dart';
import '../widgets/interactive_map.dart';
import '../widgets/common_widgets.dart';
import '../widgets/bottom_nav_bar.dart';

class GestorScreen extends StatefulWidget {
  const GestorScreen({super.key});

  @override
  State<GestorScreen> createState() => _GestorScreenState();
}

class _GestorScreenState extends State<GestorScreen> {
  int _selectedNavIndex = 1;
  int _selectedTabIndex = 1;

  // Collection points for Gestor view - more points in a grid pattern
  List<CollectionPoint> get _collectionPoints {
    final points = <CollectionPoint>[];
    int id = 1;

    // Generate points following the route
    final completedPositions = [
      // Row 1
      const Offset(0.14, 0.12), const Offset(0.38, 0.12),
      const Offset(0.62, 0.12), const Offset(0.82, 0.12),
      // Row 2
      const Offset(0.26, 0.24), const Offset(0.50, 0.24),
      const Offset(0.74, 0.24), const Offset(0.90, 0.24),
      // Row 3
      const Offset(0.14, 0.36), const Offset(0.38, 0.36),
      const Offset(0.62, 0.36), const Offset(0.82, 0.36),
      // Row 4
      const Offset(0.26, 0.48), const Offset(0.50, 0.48),
      const Offset(0.74, 0.48), const Offset(0.90, 0.48),
      // Row 5
      const Offset(0.14, 0.60), const Offset(0.38, 0.60),
      const Offset(0.62, 0.60), const Offset(0.82, 0.60),
      // Row 6
      const Offset(0.26, 0.72), const Offset(0.50, 0.72),
      const Offset(0.62, 0.72), const Offset(0.74, 0.72),
      // Row 7
      const Offset(0.14, 0.84), const Offset(0.38, 0.84),
      const Offset(0.50, 0.84),
    ];

    // Add completed points
    for (final pos in completedPositions) {
      points.add(CollectionPoint(
        id: id++,
        position: pos,
        status: PointStatus.completed,
      ));
    }

    // Current point
    points.add(CollectionPoint(
      id: id++,
      position: const Offset(0.82, 0.72),
      status: PointStatus.current,
      label: '28',
    ));

    // Pending points
    final pendingPositions = [
      const Offset(0.62, 0.84),
      const Offset(0.74, 0.90),
      const Offset(0.90, 0.90),
      const Offset(0.50, 0.90),
      const Offset(0.26, 0.90),
      const Offset(0.14, 0.90),
      const Offset(0.82, 0.84),
    ];

    for (final pos in pendingPositions) {
      points.add(CollectionPoint(
        id: id,
        position: pos,
        status: PointStatus.pending,
        label: '${id++}',
      ));
    }

    return points;
  }

  final List<RouteSegment> _routes = [
    // Planned full route (purple dashed)
    const RouteSegment(
      points: [
        Offset(0.08, 0.12), Offset(0.26, 0.12), Offset(0.26, 0.24),
        Offset(0.50, 0.24), Offset(0.50, 0.12), Offset(0.74, 0.12),
        Offset(0.74, 0.24), Offset(0.90, 0.24), Offset(0.90, 0.48),
        Offset(0.74, 0.48), Offset(0.74, 0.72), Offset(0.90, 0.72),
        Offset(0.90, 0.90), Offset(0.74, 0.90), Offset(0.50, 0.90),
        Offset(0.50, 0.72), Offset(0.26, 0.72), Offset(0.26, 0.90),
        Offset(0.08, 0.90), Offset(0.08, 0.72), Offset(0.26, 0.72),
        Offset(0.26, 0.48), Offset(0.08, 0.48),
      ],
      status: PointStatus.pending,
    ),
    // Completed route (green solid)
    const RouteSegment(
      points: [
        Offset(0.08, 0.12), Offset(0.26, 0.12), Offset(0.26, 0.24),
        Offset(0.50, 0.24), Offset(0.50, 0.12), Offset(0.74, 0.12),
        Offset(0.74, 0.24), Offset(0.90, 0.24), Offset(0.90, 0.48),
        Offset(0.74, 0.48), Offset(0.74, 0.60),
      ],
      status: PointStatus.completed,
    ),
    // Current route (orange animated)
    const RouteSegment(
      points: [
        Offset(0.74, 0.60),
        Offset(0.74, 0.72),
      ],
      status: PointStatus.current,
    ),
  ];

  final List<StreetLabel> _streetLabels = [
    const StreetLabel(name: 'R. Pereira Valente', position: Offset(0.04, 0.20)),
    const StreetLabel(name: 'R. Torres Câmara', position: Offset(0.04, 0.44)),
    const StreetLabel(name: 'R. Vicente Leite', position: Offset(0.04, 0.68)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Circuit Info
                    const CircuitInfoCard(
                      circuitId: 'CIRCUITO 01010101-AM038',
                      date: 'QUA 2026-01-21',
                    ),

                    // Tabs
                    TabSelector(
                      tabs: const ['Local', 'Mapa', 'Lista'],
                      selectedIndex: _selectedTabIndex,
                      onTabSelected: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),

                    // Progress
                    const ProgressSection(
                      current: 28,
                      total: 35,
                    ),

                    // Map
                    InteractiveMap(
                      collectionPoints: _collectionPoints,
                      routes: _routes,
                      truckPosition: const Offset(0.78, 0.68),
                      streetLabels: _streetLabels,
                      poiLabels: const [],
                      height: 300,
                    ),

                    const SizedBox(height: 12),

                    // Stats Grid
                    _buildStatsGrid(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            BottomNavBar(
              items: const [
                NavItem(icon: '📊', label: 'Dashboard'),
                NavItem(icon: '🗺️', label: 'Rotas'),
                NavItem(icon: '🚛', label: 'Frota'),
                NavItem(icon: '📋', label: 'Relatórios'),
              ],
              selectedIndex: _selectedNavIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedNavIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _buildBackButton(),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gestor',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'CherryTrack',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const StatusBadge(text: 'Em Rota', isWarning: true),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(
                  value: '28',
                  label: 'Coletados',
                  valueColor: AppTheme.lightGreen,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  value: '7',
                  label: 'Pendentes',
                  valueColor: AppTheme.warningOrange,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  value: '0',
                  label: 'Informados',
                  valueColor: AppTheme.accentBlue,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  value: '35',
                  label: 'Total',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
