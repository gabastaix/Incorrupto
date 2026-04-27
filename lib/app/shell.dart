import 'package:flutter/material.dart';
import '../design/figma_contract.dart';
import '../screens/home/home_screen.dart';
import '../screens/explorer/explorer_screen.dart';
import '../screens/sujets/sujets_screen.dart';
import '../screens/profil/profil_screen.dart';

class Shell extends StatefulWidget {
  final VoidCallback onLogout;
  final String userName;

  const Shell({super.key, required this.onLogout, required this.userName});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _tabIndex = 0;

  // 4 tabs now
  late final List<Widget> _tabs = [
    HomeScreen(userName: widget.userName),
    const ExplorerScreen(),
    const SujetsScreen(),
    ProfileScreen(onLogout: widget.onLogout, userName: widget.userName),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaContract.bg,
      body: _tabs[_tabIndex],
      bottomNavigationBar: _BottomNavBar(
        index: _tabIndex,
        onChanged: (i) => setState(() => _tabIndex = i),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _BottomNavBar({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FigmaContract.surface,
        border: Border(top: BorderSide(color: FigmaContract.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                label: 'Accueil',
                icon: Icons.home_outlined,
                selected: index == 0,
                onTap: () => onChanged(0),
              ),
              _NavItem(
                label: 'Explorer',
                icon: Icons.explore_outlined,
                selected: index == 1,
                onTap: () => onChanged(1),
              ),
              _NavItem(
                label: 'Sujets',
                icon: Icons.menu_book_outlined,
                selected: index == 2,
                onTap: () => onChanged(2),
              ),
              _NavItem(
                label: 'Profil',
                icon: Icons.person_outline,
                selected: index == 3,
                onTap: () => onChanged(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? FigmaContract.textPrimary : FigmaContract.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                style: FigmaContract.caption().copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}