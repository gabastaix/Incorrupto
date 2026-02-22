// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import '../../design/figma_contract.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = FigmaContract.bg;
    final surface = FigmaContract.surface;
    final border = FigmaContract.border;
    final textPrimary = FigmaContract.textPrimary;
    final textSecondary = FigmaContract.textSecondary;

    // Mock user data (backend later)
    const userName = 'Léa';
    const userHandle = '@lea';
    const bio =
        "Votre fil est personnalisé selon les sujets que vous suivez. Ajustez vos préférences ici.";
    const interests = [
      'Transition énergétique',
      'Intelligence artificielle',
      'Géopolitique',
      'Économie',
      'Santé',
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil',
                style: FigmaContract.h1().copyWith(color: textPrimary),
              ),
              const SizedBox(height: 14),

              // Top user card
              Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(FigmaContract.rLg),
                  border: Border.all(color: border),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: bg,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                        style: FigmaContract.body().copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: FigmaContract.body().copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userHandle,
                            style: FigmaContract.caption().copyWith(
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            bio,
                            style: FigmaContract.body().copyWith(
                              color: textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Interests
              Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(FigmaContract.rLg),
                  border: Border.all(color: border),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "VOS SUJETS",
                      style: FigmaContract.caption().copyWith(
                        color: textSecondary.withOpacity(0.75),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: interests
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: border),
                              ),
                              child: Text(
                                tag,
                                style: FigmaContract.caption().copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 14),

                    // CTA: manage preferences
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('TODO: gérer mes sujets (écran à faire)'),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Gérer mes sujets',
                          style: FigmaContract.body().copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Settings / account actions
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(FigmaContract.rLg),
                    border: Border.all(color: border),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _ProfileRow(
                        icon: Icons.notifications_none,
                        title: 'Notifications',
                        subtitle: 'Gérer les alertes et breaking news',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('TODO: notifications')),
                          );
                        },
                      ),
                      _ProfileRow(
                        icon: Icons.lock_outline,
                        title: 'Confidentialité',
                        subtitle: 'Contrôler qui voit vos sujets',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('TODO: confidentialité')),
                          );
                        },
                      ),
                      _ProfileRow(
                        icon: Icons.star_border,
                        title: 'Premium',
                        subtitle: 'Découvrir les avantages',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('TODO: premium')),
                          );
                        },
                      ),
                      _ProfileRow(
                        icon: Icons.help_outline,
                        title: 'Aide',
                        subtitle: 'FAQ et support',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('TODO: aide')),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Divider(color: border),
                      const SizedBox(height: 8),
                      _DangerRow(
                        title: 'Se déconnecter',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('TODO: logout')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = FigmaContract.textPrimary;
    final textSecondary = FigmaContract.textSecondary;
    final border = FigmaContract.border;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: FigmaContract.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: Icon(icon, color: textPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FigmaContract.body().copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: FigmaContract.caption().copyWith(color: textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: textSecondary),
          ],
        ),
      ),
    );
  }
}

class _DangerRow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DangerRow({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final border = FigmaContract.border;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Center(
          child: Text(
            title,
            style: FigmaContract.body().copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
