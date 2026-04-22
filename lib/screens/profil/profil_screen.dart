// lib/screens/profil/profil_screen.dart
import 'package:flutter/material.dart';
import '../../design/figma_contract.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _language = 'Français'; // local state for language

  @override
  Widget build(BuildContext context) {
    const userName = 'Léa';
    const bio =
        'Votre fil est personnalisé selon les sujets que vous suivez.';

    return Scaffold(
      backgroundColor: FigmaContract.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profil',
                  style: FigmaContract.h1()
                      .copyWith(color: FigmaContract.textPrimary)),
              const SizedBox(height: 14),

              // ── User card (name + bio only, no social handle) ────
              _UserCard(userName: userName, bio: bio),
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
                    style: FigmaContract.body().copyWith(
                        color: FigmaContract.textPrimary,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('Langue de l\'application',
                    style: FigmaContract.caption()
                        .copyWith(color: FigmaContract.textSecondary)),
              ],
            ),
          ),
          // Pill toggle: Français | English
          Container(
            decoration: BoxDecoration(
              color: FigmaContract.bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: FigmaContract.border),
            ),
            padding: const EdgeInsets.all(3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: languages.map((lang) {
                final selected = lang == currentLanguage;
                return GestureDetector(
                  onTap: () => onChanged(lang),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? FigmaContract.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      lang,
                      style: FigmaContract.caption().copyWith(
                        color: selected
                            ? Colors.white
                            : FigmaContract.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sheets & dialogs
// ─────────────────────────────────────────────────────────────────────────────

void _showNotificationsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
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
    isScrollControlled: true,
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
    isScrollControlled: true,
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
    isScrollControlled: true,
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
            // TODO backend: appel logout
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

// ─────────────────────────────────────────────────────────────────────────────
// Notifications sheet
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationsSheet extends StatefulWidget {
  const _NotificationsSheet();

  @override
  State<_NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<_NotificationsSheet> {
  bool _breaking  = true;
  bool _daily     = true;
  bool _weekly    = false;
  bool _newTopics = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHeader(title: 'Notifications'),
            const SizedBox(height: 6),
            Text(
              'Choisissez quand vous souhaitez être alerté.',
              style: FigmaContract.caption()
                  .copyWith(color: FigmaContract.textSecondary),
            ),
            const SizedBox(height: 20),
            _ToggleRow(
              title: 'Breaking news',
              subtitle: 'Alertes immédiates sur les actualités urgentes',
              value: _breaking,
              onChanged: (v) => setState(() => _breaking = v),
            ),
            _ToggleRow(
              title: 'Résumé quotidien',
              subtitle: 'Une synthèse chaque matin',
              value: _daily,
              onChanged: (v) => setState(() => _daily = v),
            ),
            _ToggleRow(
              title: 'Récap hebdomadaire',
              subtitle: 'Le meilleur de la semaine le dimanche',
              value: _weekly,
              onChanged: (v) => setState(() => _weekly = v),
            ),
            _ToggleRow(
              title: 'Nouveaux sujets suggérés',
              subtitle: 'Quand un sujet correspond à vos intérêts',
              value: _newTopics,
              onChanged: (v) => setState(() => _newTopics = v),
            ),
            const SizedBox(height: 8),
            _SheetSaveButton(onTap: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Privacy sheet — stripped of social features
// ─────────────────────────────────────────────────────────────────────────────

class _PrivacySheet extends StatefulWidget {
  const _PrivacySheet();

  @override
  State<_PrivacySheet> createState() => _PrivacySheetState();
}

class _PrivacySheetState extends State<_PrivacySheet> {
  bool _analytics = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHeader(title: 'Confidentialité'),
            const SizedBox(height: 6),
            Text(
              'Gérez vos données et la façon dont elles sont utilisées.',
              style: FigmaContract.caption()
                  .copyWith(color: FigmaContract.textSecondary),
            ),
            const SizedBox(height: 20),
            _ToggleRow(
              title: 'Amélioration du service',
              subtitle:
                  'Données anonymes pour améliorer les recommandations',
              value: _analytics,
              onChanged: (v) => setState(() => _analytics = v),
            ),
            const SizedBox(height: 8),
            _SheetSaveButton(onTap: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Premium sheet
// ─────────────────────────────────────────────────────────────────────────────

class _PremiumSheet extends StatelessWidget {
  const _PremiumSheet();

  @override
  Widget build(BuildContext context) {
    const features = [
      ('Analyses illimitées', 'Accédez à toutes les analyses sans restriction'),
      ('Résumés audio', 'Écoutez les résumés pendant vos trajets'),
      ('Archives complètes', 'Accédez à tout l\'historique des débats'),
      ('Sans publicité', 'Une expérience de lecture sans interruption'),
      ('Alertes prioritaires', 'Soyez notifié en premier sur les breaking news'),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHeader(title: 'Premium ✦'),
            const SizedBox(height: 6),
            Text('Tout comprendre, sans limite.',
                style: FigmaContract.caption()
                    .copyWith(color: FigmaContract.textSecondary)),
            const SizedBox(height: 20),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: FigmaContract.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check,
                            size: 13, color: FigmaContract.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.$1,
                                style: FigmaContract.body().copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: FigmaContract.textPrimary)),
                            Text(f.$2,
                                style: FigmaContract.caption().copyWith(
                                    color: FigmaContract.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: FigmaContract.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                ),
                child: Text('Passer à Premium — 4,99 € / mois',
                    style: FigmaContract.body().copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Help sheet
// ─────────────────────────────────────────────────────────────────────────────

class _HelpSheet extends StatelessWidget {
  const _HelpSheet();

  @override
  Widget build(BuildContext context) {
    const faqs = [
      (
        'Comment fonctionne Incorrupto ?',
        'Incorrupto agrège des sources fiables et présente chaque actualité '
            'avec un résumé neutre et plusieurs points de vue distincts. '
            'Vous suivez les sujets qui vous intéressent et recevez une '
            'newsletter personnalisée.'
      ),
      (
        'Les contenus sont-ils vérifiés ?',
        'Oui, nous ne référençons que des sources vérifiées et reconnues. '
            'Chaque résumé est présenté sans opinion ni biais éditorial.'
      ),
      (
        'Comment modifier mes sujets suivis ?',
        'Rendez-vous dans l\'onglet "Sujets" pour ajouter ou supprimer '
            'des sujets, et ajuster la fréquence de réception.'
      ),
      (
        'Comment contacter le support ?',
        'Envoyez-nous un email à support@incorrupto.fr — nous répondons '
            'sous 24 h en jours ouvrés.'
      ),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHeader(title: 'Aide & FAQ'),
            const SizedBox(height: 16),
            ...faqs.map((faq) => _FaqItem(q: faq.$1, a: faq.$2)),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String q;
  final String a;
  const _FaqItem({required this.q, required this.a});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.q,
                      style: FigmaContract.body().copyWith(
                          fontWeight: FontWeight.w700,
                          color: FigmaContract.textPrimary)),
                ),
                Icon(
                  _open ? Icons.expand_less : Icons.expand_more,
                  color: FigmaContract.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (_open)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(widget.a,
                style: FigmaContract.body().copyWith(
                    color: FigmaContract.textSecondary, height: 1.5)),
          ),
        Divider(color: FigmaContract.border, height: 1),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable sheet widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  final String title;
  const _SheetHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style: FigmaContract.h2()
                  .copyWith(color: FigmaContract.textPrimary)),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          color: FigmaContract.textSecondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: FigmaContract.body().copyWith(
                        fontWeight: FontWeight.w600,
                        color: FigmaContract.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: FigmaContract.caption()
                        .copyWith(color: FigmaContract.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: FigmaContract.primary,
          ),
        ],
      ),
    );
  }
}

class _SheetSaveButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SheetSaveButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: FigmaContract.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
        ),
        child: Text('Enregistrer',
            style: FigmaContract.body().copyWith(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile sub-widgets
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: FigmaContract.primaryLight,
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : '?',
              style: FigmaContract.body().copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: FigmaContract.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,
                    style: FigmaContract.body().copyWith(
                        color: FigmaContract.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 18)),
                const SizedBox(height: 6),
                Text(bio,
                    style: FigmaContract.body().copyWith(
                        color: FigmaContract.textSecondary,
                        height: 1.35)),
              ],
            ),
          ),
        ],
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
                      style: FigmaContract.body().copyWith(
                          color: FigmaContract.textPrimary,
                          fontWeight: FontWeight.w700)),
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

class _DangerRow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _DangerRow({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: FigmaContract.border),
        ),
        child: Center(
          child: Text(title,
              style: FigmaContract.body().copyWith(
                  color: FigmaContract.danger,
                  fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }
}