import 'package:flutter/material.dart';
import '../design/figma_contract.dart';
import '../screens/home/home_screen.dart';
import '../screens/explorer/explorer_screen.dart';
import '../screens/sujets/sujets_screen.dart';
import '../screens/messages/messages_screen.dart';
import '../screens/profil/profil_screen.dart';



class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _tabIndex = 0;

  // These are the 5 tabs
  late final List<Widget> _tabs = [
    const HomeScreen(),       // Accueil
    const ExplorerScreen(),   // Explorer
    const SujetsScreen(),
    const MessagesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaContract.bg,

      // This shows the current tab screen
      body: _tabs[_tabIndex],

      // Bottom nav always visible here
      bottomNavigationBar: _BottomNavBar(
        index: _tabIndex,
        onChanged: (i) => setState(() => _tabIndex = i),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;
  const _PlaceholderTab({required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          title,
          style: FigmaContract.h1(),
        ),
      ),
    );
  }
}

/// Same bottom nav you already made, copied here so the shell controls it.
/// Later we can move this into a shared widgets folder.
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
                label: 'Messages',
                icon: Icons.chat_bubble_outline,
                selected: index == 3,
                onTap: () => onChanged(3),
              ),
              _NavItem(
                label: 'Profil',
                icon: Icons.person_outline,
                selected: index == 4,
                onTap: () => onChanged(4),
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
