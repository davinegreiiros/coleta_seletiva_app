import 'package:flutter/material.dart';
import '../models/collection_point.dart';
import '../theme/app_theme.dart';
import '../widgets/interactive_map.dart';
import '../widgets/common_widgets.dart';
import '../widgets/bottom_nav_bar.dart';

class MunicipeScreen extends StatefulWidget {
  const MunicipeScreen({super.key});

  @override
  State<MunicipeScreen> createState() => _MunicipeScreenState();
}

class _MunicipeScreenState extends State<MunicipeScreen> {
  int _selectedNavIndex = 0;

  // Sample data for the map
  final List<CollectionPoint> _collectionPoints = [
    const CollectionPoint(id: 1, position: Offset(0.14, 0.80), status: PointStatus.completed),
    const CollectionPoint(id: 2, position: Offset(0.29, 0.80), status: PointStatus.completed),
    const CollectionPoint(id: 3, position: Offset(0.29, 0.54), status: PointStatus.completed),
    const CollectionPoint(id: 4, position: Offset(0.47, 0.54), status: PointStatus.completed),
    const CollectionPoint(id: 5, position: Offset(0.61, 0.54), status: PointStatus.completed),
    const CollectionPoint(id: 6, position: Offset(0.61, 0.25), status: PointStatus.completed),
    const CollectionPoint(id: 7, position: Offset(0.84, 0.25), status: PointStatus.current, label: '!'),
    const CollectionPoint(id: 8, position: Offset(0.84, 0.54), status: PointStatus.pending, label: '8'),
    const CollectionPoint(id: 9, position: Offset(0.84, 0.80), status: PointStatus.pending, label: '9'),
    const CollectionPoint(id: 10, position: Offset(0.47, 0.80), status: PointStatus.pending, label: '10'),
  ];

  final List<RouteSegment> _routes = [
    // Completed route
    const RouteSegment(
      points: [
        Offset(0.14, 0.92),
        Offset(0.14, 0.80),
        Offset(0.29, 0.80),
        Offset(0.29, 0.54),
        Offset(0.61, 0.54),
        Offset(0.61, 0.25),
        Offset(0.84, 0.25),
      ],
      status: PointStatus.completed,
    ),
    // Current route
    const RouteSegment(
      points: [
        Offset(0.84, 0.25),
        Offset(0.84, 0.40),
      ],
      status: PointStatus.current,
    ),
    // Pending route
    const RouteSegment(
      points: [
        Offset(0.84, 0.40),
        Offset(0.84, 0.54),
        Offset(0.84, 0.80),
        Offset(0.61, 0.80),
        Offset(0.29, 0.80),
        Offset(0.29, 0.92),
      ],
      status: PointStatus.pending,
    ),
  ];

  final List<StreetLabel> _streetLabels = [
    const StreetLabel(name: 'Av. Santos Dumont', position: Offset(0.05, 0.22)),
    const StreetLabel(name: 'R. Torres Câmara', position: Offset(0.05, 0.51)),
    const StreetLabel(name: 'Av. Dom Luís', position: Offset(0.05, 0.77)),
    const StreetLabel(name: 'R. Osvaldo Cruz', position: Offset(0.30, 0.08), isVertical: true),
  ];

  final List<PoiLabel> _poiLabels = [
    const PoiLabel(name: 'Shopping Aldeota', position: Offset(0.38, 0.08)),
    const PoiLabel(name: 'Praça Portugal', position: Offset(0.65, 0.62)),
    const PoiLabel(name: 'Pç. das Flores', position: Offset(0.08, 0.33), isGreen: true),
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
                    // Title Card
                    const TitleCard(
                      icon: '🗑️',
                      title: 'Coleta Seletiva',
                      subtitle: 'Acompanhe o serviço em tempo real',
                    ),

                    // Map
                    InteractiveMap(
                      collectionPoints: _collectionPoints,
                      routes: _routes,
                      truckPosition: const Offset(0.84, 0.35),
                      userPosition: const Offset(0.47, 0.43),
                      streetLabels: _streetLabels,
                      poiLabels: _poiLabels,
                      height: 340,
                    ),

                    // Info Card
                    const InfoCard(
                      icon: '📍',
                      text: 'O mapa mostra sua localização, a posição do veículo de coleta e a rota em execução em tempo real.',
                    ),

                    // Status Section
                    const StatusSection(
                      title: 'Serviço Disponível',
                      isActive: true,
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            BottomNavBar(
              items: const [
                NavItem(icon: '🏠', label: 'Início'),
                NavItem(icon: '📅', label: 'Agenda'),
                NavItem(icon: '📞', label: 'CHEGADA', sublabel: '~15min'),
                NavItem(icon: '⚙️', label: 'Config'),
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
                  'Munícipe',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Fortaleza, CE',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const StatusBadge(text: 'Ativo'),
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
}
