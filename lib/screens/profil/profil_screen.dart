// lib/screens/profil/profil_screen.dart
import 'package:flutter/material.dart';
import '../../design/figma_contract.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final String userName;

  const ProfileScreen({super.key, required this.onLogout, required this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _language = 'Français'; // local state for language

  @override
  Widget build(BuildContext context) {
    final bio =
        'Votre fil est personnalisé selon les sujets que vous suivez.';

    return Scaffold(
      backgroundColor: FigmaContract.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bienvenue ${widget.userName}',
                  style: FigmaContract.h1()
                      .copyWith(color: FigmaContract.textPrimary)),
              const SizedBox(height: 14),

              // ── User card (name + bio only, no social handle) ────
              _UserCard(userName: widget.userName, bio: bio),
              const SizedBox(height: 14),

              // ── Settings list ────────────────────────────────────
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: FigmaContract.surface,
                    borderRadius:
                        BorderRadius.circular(FigmaContract.rLg),
                    border: Border.all(color: FigmaContract.border),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _ProfileRow(
                        icon: Icons.notifications_none,
                        title: 'Notifications',
                        subtitle: 'Gérer les alertes et breaking news',
                        onTap: () => _showNotificationsSheet(context),
                      ),
                      _ProfileRow(
                        icon: Icons.lock_outline,
                        title: 'Confidentialité',
                        subtitle: 'Données et amélioration du service',
                        onTap: () => _showPrivacySheet(context),
                      ),
                      // ── Language row ─────────────────────────────
                      _LanguageRow(
                        currentLanguage: _language,
                        onChanged: (lang) =>
                            setState(() => _language = lang),
                      ),
                      _ProfileRow(
                        icon: Icons.star_border,
                        title: 'Premium',
                        subtitle: 'Découvrir les avantages',
                        onTap: () => _showPremiumSheet(context),
                      ),
                      _ProfileRow(
                        icon: Icons.help_outline,
                        title: 'Aide',
                        subtitle: 'FAQ et support',
                        onTap: () => _showHelpSheet(context),
                      ),
                      const SizedBox(height: 8),
                      Divider(color: FigmaContract.border),
                      const SizedBox(height: 8),
                      _DangerRow(
                        title: 'Se déconnecter',
                        onTap: () => _confirmLogout(context),
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

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FigmaContract.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _NotificationsSheet(),
    );
  }

  void _showPrivacySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FigmaContract.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _PrivacySheet(),
    );
  }

  void _showPremiumSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FigmaContract.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _PremiumSheet(),
    );
  }

  void _showHelpSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FigmaContract.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _HelpSheet(),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FigmaContract.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FigmaContract.rLg)),
        title: Text('Se déconnecter',
            style: FigmaContract.h2()
                .copyWith(color: FigmaContract.textPrimary)),
        content: Text(
          'Voulez-vous vraiment vous déconnecter ?',
          style: FigmaContract.body()
              .copyWith(color: FigmaContract.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Annuler',
                style: FigmaContract.body()
                    .copyWith(color: FigmaContract.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onLogout();
            },
            child: Text('Se déconnecter',
                style: FigmaContract.body().copyWith(
                    color: FigmaContract.danger,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// User card — name + bio only, no social handle
// ─────────────────────────────────────────────────────────────────────────────

class _UserCard extends StatelessWidget {
  final String userName;
  final String bio;

  const _UserCard({required this.userName, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FigmaContract.surface,
        borderRadius: BorderRadius.circular(FigmaContract.rLg),
        border: Border.all(color: FigmaContract.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: FigmaContract.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                userName[0].toUpperCase(),
                style: FigmaContract.h2()
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,
                    style: FigmaContract.h2()
                        .copyWith(color: FigmaContract.textPrimary)),
                const SizedBox(height: 2),
                Text(bio,
                    style: FigmaContract.caption()
                        .copyWith(color: FigmaContract.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile row — standard settings row
// ─────────────────────────────────────────────────────────────────────────────

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
                border: Border.all(color: FigmaContract.border),
              ),
              child: Icon(icon, color: FigmaContract.textPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: FigmaContract.body()
                          .copyWith(color: FigmaContract.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: FigmaContract.caption()
                          .copyWith(color: FigmaContract.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: FigmaContract.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Language row — inline selector, no separate sheet needed
// ─────────────────────────────────────────────────────────────────────────────

class _LanguageRow extends StatelessWidget {
  final String currentLanguage;
  final ValueChanged<String> onChanged;

  const _LanguageRow(
      {required this.currentLanguage, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const languages = ['Français', 'English'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: FigmaContract.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FigmaContract.border),
            ),
            child:
                Icon(Icons.language, color: FigmaContract.textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Langue',
                    style: FigmaContract.body()
                        .copyWith(color: FigmaContract.textPrimary)),
                const SizedBox(height: 2),
                Text('Choisir la langue de l\'application',
                    style: FigmaContract.caption()
                        .copyWith(color: FigmaContract.textSecondary)),
              ],
            ),
          ),
          DropdownButton<String>(
            value: currentLanguage,
            items: languages
                .map((lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(lang,
                          style: FigmaContract.body()
                              .copyWith(color: FigmaContract.textPrimary)),
                    ))
                .toList(),
            onChanged: (value) => onChanged(value!),
            underline: const SizedBox(),
            icon: Icon(Icons.chevron_right, color: FigmaContract.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Danger row — for logout, styled in red
// ─────────────────────────────────────────────────────────────────────────────

class _DangerRow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DangerRow({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                color: FigmaContract.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: FigmaContract.danger.withOpacity(0.2)),
              ),
              child: Icon(Icons.logout, color: FigmaContract.danger),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: FigmaContract.body()
                      .copyWith(color: FigmaContract.danger)),
            ),
            Icon(Icons.chevron_right, color: FigmaContract.danger),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sheet widgets — placeholder implementations
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Notifications',
              style: FigmaContract.h2()
                  .copyWith(color: FigmaContract.textPrimary)),
          const SizedBox(height: 20),
          Text('Paramètres de notifications à implémenter',
              style: FigmaContract.body()
                  .copyWith(color: FigmaContract.textSecondary)),
        ],
      ),
    );
  }
}

class _PrivacySheet extends StatelessWidget {
  const _PrivacySheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Confidentialité',
              style: FigmaContract.h2()
                  .copyWith(color: FigmaContract.textPrimary)),
          const SizedBox(height: 20),
          Text('Paramètres de confidentialité à implémenter',
              style: FigmaContract.body()
                  .copyWith(color: FigmaContract.textSecondary)),
        ],
      ),
    );
  }
}

class _PremiumSheet extends StatelessWidget {
  const _PremiumSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Premium',
              style: FigmaContract.h2()
                  .copyWith(color: FigmaContract.textPrimary)),
          const SizedBox(height: 20),
          Text('Fonctionnalités premium à implémenter',
              style: FigmaContract.body()
                  .copyWith(color: FigmaContract.textSecondary)),
        ],
      ),
    );
  }
}

class _HelpSheet extends StatelessWidget {
  const _HelpSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Aide',
              style: FigmaContract.h2()
                  .copyWith(color: FigmaContract.textPrimary)),
          const SizedBox(height: 20),
          Text('FAQ et support à implémenter',
              style: FigmaContract.body()
                  .copyWith(color: FigmaContract.textSecondary)),
        ],
      ),
    );
  }
}