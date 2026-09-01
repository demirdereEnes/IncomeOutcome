import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_typography.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/movements/presentation/movements_screen.dart';
import 'app_router.dart';

/// Bottom navigation shell: Özet | (+) | Hareketler.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const _titles = ['Finansal Durum', 'Hareketler'];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: IndexedStack(
        index: _index,
        children: [
          DashboardScreen(
            onSeeAllTransactions: () => _select(1),
            onAddTransaction: _openNewTransaction,
          ),
          MovementsScreen(onAddTransaction: _openNewTransaction),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNewTransaction,
        tooltip: 'Yeni İşlem',
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x141B1B1F),
        elevation: 8,
        height: 68,
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          children: [
            Expanded(
              child: _NavItem(
                icon: Icons.pie_chart_outline_rounded,
                selectedIcon: Icons.pie_chart_rounded,
                label: 'Özet',
                isSelected: _index == 0,
                onTap: () => _select(0),
              ),
            ),
            const SizedBox(width: 72),
            Expanded(
              child: _NavItem(
                icon: Icons.receipt_long_outlined,
                selectedIcon: Icons.receipt_long_rounded,
                label: 'Hareketler',
                isSelected: _index == 1,
                onTap: () => _select(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _select(int index) {
    if (_index != index) setState(() => _index = index);
  }

  void _openNewTransaction() {
    Navigator.of(context).pushNamed(AppRoutes.newTransaction);
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.textTertiary;

    return InkResponse(
      onTap: onTap,
      radius: 44,
      highlightShape: BoxShape.circle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isSelected ? selectedIcon : icon, size: 22, color: color),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
