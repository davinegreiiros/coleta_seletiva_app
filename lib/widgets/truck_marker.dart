import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TruckMarker extends StatelessWidget {
  final double size;

  const TruckMarker({
    super.key,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppTheme.errorRed.withOpacity(0.5),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '🚛',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
