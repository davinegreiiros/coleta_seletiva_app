import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NavItem {
  final String icon;
  final String label;
  final String? sublabel;

  const NavItem({
    required this.icon,
    required this.label,
    this.sublabel,
  });
}

class BottomNavBar extends StatelessWidget {
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const BottomNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 28),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark.withOpacity(0.95),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final isSelected = entry.key == selectedIndex;
          final item = entry.value;

          return GestureDetector(
            onTap: () => onItemSelected(entry.key),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF0969DA), Color(0xFF1F6FEB)],
                          )
                        : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      item.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                if (item.sublabel != null) ...[
                  Text(
                    item.sublabel!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentBlue,
                    ),
                  ),
                ],
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppTheme.accentBlue
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
