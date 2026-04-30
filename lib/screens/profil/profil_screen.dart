import 'package:flutter/material.dart';
import '../../design/figma_contract.dart';
import '../../services/app_settings_service.dart';
import '../../services/locale_service.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final String userName;
  final LocaleService localeService;
  final AppSettingsService appSettingsService;

  const ProfileScreen({
    super.key,
    required this.onLogout,
    required this.userName,
    required this.localeService,
    required this.appSettingsService,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final palette = _ProfilePalette.of(context);

    return Scaffold(
      backgroundColor: palette.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mon profil',
                style: FigmaContract.h1().copyWith(color: palette.textPrimary),
              ),
              const SizedBox(height: 14),
              _UserCard(
                userName: widget.userName,
                palette: palette,
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _SectionHeader(title: 'Compte', palette: palette),
                    _SettingsCard(
                      palette: palette,
                      children: [
                        _ProfileRow(
                          palette: palette,
                          icon: Icons.person_outline,
                          title: 'Profil',
                          subtitle: 'Nom, email, mot de passe',
                          onTap: () => _showSheet(
                            context,
                            _ProfileEditSheet(palette: palette),
                          ),
                        ),
                        LanguageRowWidget(
                          localeService: widget.localeService,
                          parentContext: context,
                          palette: palette,
                        ),
                      ],
                    ),

                    _SectionHeader(title: 'Notifications', palette: palette),
                    _SettingsCard(
                      palette: palette,
                      children: [
                        _ProfileRow(
                          palette: palette,
                          icon: Icons.notifications_none,
                          title: 'Breaking news',
                          subtitle: 'Alertes en temps réel',
                          trailing: Switch(
                            value: widget.appSettingsService.pushBreakingNews,
                            onChanged:
                                widget.appSettingsService.setPushBreakingNews,
                          ),
                        ),
                        _ProfileRow(
                          palette: palette,
                          icon: Icons.mail_outline,
                          title: 'Emails',
                          subtitle: 'Résumés et newsletters',
                          trailing: Switch(
                            value: widget.appSettingsService.emailNewsletter,
                            onChanged:
                                widget.appSettingsService.setEmailNewsletter,
                          ),
                        ),
                        _ProfileRow(
                          palette: palette,
                          icon: Icons.topic_outlined,
                          title: 'Alertes par sujet',
                          subtitle: 'Sujets que vous suivez',
                          trailing: Switch(
                            value: widget.appSettingsService.topicAlerts,
                            onChanged: widget.appSettingsService.setTopicAlerts,
                          ),
                        ),
                      ],
                    ),

                    _SectionHeader(title: 'Préférences', palette: palette),
                    _SettingsCard(
                      palette: palette,
                      children: [
                        _ProfileRow(
                          palette: palette,
                          icon: Icons.accessibility_new_outlined,
                          title: 'Accessibilité',
                          subtitle: 'Taille du texte, contraste, animations',
                          onTap: () => _showSheet(
                            context,
                            _AccessibilitySheet(
                              palette: palette,
                              settings: widget.appSettingsService,
                            ),
                          ),
                        ),
                        _ProfileRow(
                          palette: palette,
                          icon: Icons.dark_mode_outlined,
                          title: 'Thème',
                          subtitle: 'Clair ou sombre',
                          onTap: () => _showSheet(
                            context,
                            _ThemeSheet(
                              palette: palette,
                              settings: widget.appSettingsService,
                            ),
                          ),
                        ),
                        _ProfileRow(
                          palette: palette,
                          icon: Icons.article_outlined,
                          title: 'Formats de contenu',
                          subtitle: 'Résumés, articles complets, audio',
                          onTap: () => _showSheet(
                            context,
                            _ContentFormatSheet(
                              palette: palette,
                              settings: widget.appSettingsService,
                            ),
                          ),
                        ),
                      ],
                    ),

                    _SectionHeader(title: 'Premium', palette: palette),
                    _SettingsCard(
                      palette: palette,
                      children: [
                        _ProfileRow(
                          palette: palette,
                          icon: Icons.workspace_premium_outlined,
                          title: 'Passer à Premium',
                          subtitle: 'Débloquer les fonctionnalités avancées',
                          onTap: () => _showSheet(
                            context,
                            _PremiumSheet(palette: palette),
                          ),
                        ),
                      ],
                    ),

                    _SectionHeader(
                      title: 'Confiance et support',
                      palette: palette,
                    ),
                    _SettingsCard(
                      palette: palette,
                      children: [
                        _ProfileRow(
                          palette: palette,
                          icon: Icons.shield_outlined,
                          title: 'Centre de confiance',
                          subtitle:
                              'Confidentialité, aide, méthodologie et légal',
                          onTap: () => _showSheet(
                            context,
                            _TrustCenterSheet(
                              palette: palette,
                              onDeleteData: () {
                                Navigator.of(context).pop();
                                _confirmDeleteData(context, palette);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    _SettingsCard(
                      palette: palette,
                      children: [
                        _DangerRow(
                          palette: palette,
                          icon: Icons.logout,
                          title: 'Se déconnecter',
                          onTap: () => _confirmLogout(context, palette),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSheet(BuildContext context, Widget sheet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => sheet,
    );
  }

  void _confirmLogout(BuildContext context, _ProfilePalette palette) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FigmaContract.rLg),
        ),
        title: Text(
          'Se déconnecter',
          style: FigmaContract.h2().copyWith(color: palette.textPrimary),
        ),
        content: Text(
          'Voulez-vous vraiment vous déconnecter ?',
          style: FigmaContract.body().copyWith(color: palette.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Annuler',
              style:
                  FigmaContract.body().copyWith(color: palette.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onLogout();
            },
            child: Text(
              'Se déconnecter',
              style: FigmaContract.body().copyWith(
                color: palette.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteData(BuildContext context, _ProfilePalette palette) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FigmaContract.rLg),
        ),
        title: Text(
          'Supprimer mes données',
          style: FigmaContract.h2().copyWith(color: palette.danger),
        ),
        content: Text(
          'Cette action est irréversible. Toutes vos données personnelles seront effacées dans un délai d\'un mois conformément au RGPD.',
          style: FigmaContract.body().copyWith(color: palette.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Annuler',
              style:
                  FigmaContract.body().copyWith(color: palette.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Supprimer',
              style: FigmaContract.body().copyWith(
                color: palette.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageRowWidget extends StatelessWidget {
  final LocaleService localeService;
  final BuildContext parentContext;
  final _ProfilePalette palette;

  const LanguageRowWidget({
    super.key,
    required this.localeService,
    required this.parentContext,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeService,
      builder: (_, __) => InkWell(
        onTap: () => showModalBottomSheet(
          context: parentContext,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => _LanguageSheet(
            localeService: localeService,
            palette: palette,
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              _LeadingIconBox(
                palette: palette,
                icon: Icons.language,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Langue',
                      style: FigmaContract.body().copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      localeService.currentLanguageName,
                      style: FigmaContract.caption().copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: palette.textSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  final String code;
  final String label;
  final String flag;

  const _LanguageOption({
    required this.code,
    required this.label,
    required this.flag,
  });
}

class _LanguageSheet extends StatefulWidget {
  final LocaleService localeService;
  final _ProfilePalette palette;

  const _LanguageSheet({
    required this.localeService,
    required this.palette,
  });

  @override
  State<_LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<_LanguageSheet> {
  late String _selected;
  bool _saving = false;

  static const _options = [
    _LanguageOption(code: 'fr', label: 'Français', flag: '🇫🇷'),
    _LanguageOption(code: 'en', label: 'English', flag: '🇬🇧'),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.localeService.locale.languageCode;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await widget.localeService.setLocale(Locale(_selected));
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;

    return _BaseSheet(
      palette: p,
      title: 'Choisir la langue',
      subtitle: 'La langue sera appliquée sur toute l’application.',
      child: Column(
        children: [
          ..._options.map((opt) {
            final isSelected = _selected == opt.code;
            return GestureDetector(
              onTap: () => setState(() => _selected = opt.code),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? p.primary.withOpacity(0.10) : p.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? p.primary : p.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(opt.flag, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        opt.label,
                        style: FigmaContract.body().copyWith(
                          color: p.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: p.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: p.onPrimary, size: 14),
                      )
                    else
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: p.border),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          _SheetButton(
            palette: p,
            label: _saving ? 'Sauvegarde...' : 'Sauvegarder',
            onTap: _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}

class _AccessibilitySheet extends StatelessWidget {
  final _ProfilePalette palette;
  final AppSettingsService settings;

  const _AccessibilitySheet({
    required this.palette,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (_, __) => _BaseSheet(
        palette: palette,
        title: 'Accessibilité',
        subtitle: 'Les changements sont appliqués à toute l’application.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Taille du texte',
              style: FigmaContract.body().copyWith(color: palette.textPrimary),
            ),
            Slider(
              value: settings.textScale,
              min: 0.9,
              max: 1.35,
              divisions: 9,
              activeColor: palette.primary,
              onChanged: settings.setTextScale,
            ),
            const SizedBox(height: 8),
            _SheetToggle(
              palette: palette,
              label: 'Contraste renforcé',
              subtitle: 'Améliore la lisibilité du thème',
              value: settings.highContrast,
              onChanged: settings.setHighContrast,
            ),
            _SheetToggle(
              palette: palette,
              label: 'Réduire les animations',
              subtitle: 'Transitions plus sobres',
              value: settings.reduceMotion,
              onChanged: settings.setReduceMotion,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSheet extends StatelessWidget {
  final _ProfilePalette palette;
  final AppSettingsService settings;

  const _ThemeSheet({
    required this.palette,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (_, __) => _BaseSheet(
        palette: palette,
        title: 'Thème',
        subtitle: 'Le thème s’applique à toute l’application.',
        child: Column(
          children: [
            _ThemeRadioTile(
              palette: palette,
              title: 'Clair',
              value: AppThemePreference.light,
              groupValue: settings.themePreference,
              onChanged: settings.setThemePreference,
            ),
            _ThemeRadioTile(
              palette: palette,
              title: 'Sombre',
              value: AppThemePreference.dark,
              groupValue: settings.themePreference,
              onChanged: settings.setThemePreference,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentFormatSheet extends StatelessWidget {
  final _ProfilePalette palette;
  final AppSettingsService settings;

  const _ContentFormatSheet({
    required this.palette,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (_, __) => _BaseSheet(
        palette: palette,
        title: 'Formats de contenu',
        subtitle: 'Préférences de lecture enregistrées.',
        child: Column(
          children: [
            _SheetToggle(
              palette: palette,
              label: 'Résumés IA',
              value: settings.showSummaries,
              onChanged: settings.setShowSummaries,
            ),
            _SheetToggle(
              palette: palette,
              label: 'Articles complets',
              value: settings.showFullArticles,
              onChanged: settings.setShowFullArticles,
            ),
            _SheetToggle(
              palette: palette,
              label: 'Audio',
              value: settings.showAudio,
              onChanged: settings.setShowAudio,
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumSheet extends StatelessWidget {
  final _ProfilePalette palette;

  const _PremiumSheet({required this.palette});

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      palette: palette,
      title: 'Incorrupto Premium',
      subtitle:
          'Approfondissez votre lecture et personnalisez davantage votre expérience.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PremiumBenefit(
            palette: palette,
            icon: Icons.all_inclusive,
            title: 'Sujets illimités',
            subtitle: 'Suivez autant de sujets que vous le souhaitez.',
          ),
          _PremiumBenefit(
            palette: palette,
            icon: Icons.auto_awesome_outlined,
            title: 'Analyses plus détaillées',
            subtitle:
                'Accédez à des résumés enrichis et des décryptages plus complets.',
          ),
          _PremiumBenefit(
            palette: palette,
            icon: Icons.schedule_outlined,
            title: 'Formats et fréquence avancés',
            subtitle:
                'Plus de contrôle sur la profondeur et le rythme de vos contenus.',
          ),
          _PremiumBenefit(
            palette: palette,
            icon: Icons.visibility_outlined,
            title: 'Lecture plus confortable',
            subtitle:
                'Une expérience plus complète pour suivre l’actualité sans friction.',
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: palette.border),
            ),
            child: Column(
              children: [
                Text(
                  '9,99 € / mois',
                  style: FigmaContract.h2().copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sans engagement',
                  style: FigmaContract.body().copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SheetButton(
            palette: palette,
            label: 'Choisir Premium',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _PremiumBenefit extends StatelessWidget {
  final _ProfilePalette palette;
  final IconData icon;
  final String title;
  final String subtitle;

  const _PremiumBenefit({
    required this.palette,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LeadingIconBox(
            palette: palette,
            icon: icon,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FigmaContract.body().copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: FigmaContract.body().copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustCenterSheet extends StatelessWidget {
  final _ProfilePalette palette;
  final VoidCallback onDeleteData;

  const _TrustCenterSheet({
    required this.palette,
    required this.onDeleteData,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      palette: palette,
      title: 'Centre de confiance',
      subtitle:
          'Confidentialité, support, signalement et documents utiles.',
      child: Column(
        children: [
          _ProfileRow(
            palette: palette,
            icon: Icons.help_outline,
            title: 'FAQ',
            subtitle: 'Questions fréquentes',
            onTap: () => _openNestedSheet(
              context,
              _DocumentSheet(
                palette: palette,
                title: 'FAQ',
                sections: const [
                  _DocSection(
                    'Comment fonctionne le fil ?',
                    'Votre fil est personnalisé selon les sujets que vous suivez.',
                  ),
                  _DocSection(
                    'Comment changer la langue ?',
                    'Depuis Compte > Langue.',
                  ),
                  _DocSection(
                    'Comment supprimer mon compte ?',
                    'Depuis le centre de confiance.',
                  ),
                ],
              ),
            ),
          ),
          Divider(color: palette.border, height: 1),
          _ProfileRow(
            palette: palette,
            icon: Icons.support_agent_outlined,
            title: 'Nous contacter',
            subtitle: 'Support et contact',
            onTap: () => _openNestedSheet(
              context,
              _SupportSheet(palette: palette),
            ),
          ),
          Divider(color: palette.border, height: 1),
          _ProfileRow(
            palette: palette,
            icon: Icons.flag_outlined,
            title: 'Signaler une erreur / un contenu',
            subtitle: 'Erreur factuelle ou contenu problématique',
            onTap: () => _openNestedSheet(
              context,
              _ReportContentSheet(palette: palette),
            ),
          ),
          Divider(color: palette.border, height: 1),
          _ProfileRow(
            palette: palette,
            icon: Icons.balance_outlined,
            title: 'Méthodologie éditoriale',
            subtitle: 'Sources, neutralité, corrections',
            onTap: () => _openNestedSheet(
              context,
              _DocumentSheet(
                palette: palette,
                title: 'Méthodologie éditoriale',
                sections: const [
                  _DocSection(
                    'Sélection des sources',
                    'Sources identifiées, pluralité des points de vue, priorité aux références fiables.',
                  ),
                  _DocSection(
                    'Neutralité',
                    'Présenter les faits et distinguer clairement les interprétations et désaccords.',
                  ),
                  _DocSection(
                    'Corrections',
                    'Les signalements sont relus et les corrections documentées.',
                  ),
                ],
              ),
            ),
          ),
          Divider(color: palette.border, height: 1),
          _ProfileRow(
            palette: palette,
            icon: Icons.handshake_outlined,
            title: 'CGU',
            subtitle: 'Conditions générales d’utilisation',
            onTap: () => _openNestedSheet(
              context,
              _DocumentSheet(
                palette: palette,
                title: 'CGU',
                sections: const [
                  _DocSection(
                    'Objet',
                    'Les présentes CGU encadrent l’utilisation de l’application Incorrupto.',
                  ),
                  _DocSection(
                    'Accès au service',
                    'Certaines fonctionnalités peuvent être réservées aux comptes connectés ou Premium.',
                  ),
                  _DocSection(
                    'Propriété intellectuelle',
                    'Les contenus et éléments graphiques sont protégés.',
                  ),
                ],
              ),
            ),
          ),
          Divider(color: palette.border, height: 1),
          _ProfileRow(
            palette: palette,
            icon: Icons.privacy_tip_outlined,
            title: 'Politique de confidentialité',
            subtitle: 'Comment vos données sont utilisées',
            onTap: () => _openNestedSheet(
              context,
              _DocumentSheet(
                palette: palette,
                title: 'Politique de confidentialité',
                sections: const [
                  _DocSection(
                    'Données collectées',
                    'Email, préférences de lecture, données techniques nécessaires au service.',
                  ),
                  _DocSection(
                    'Finalités',
                    'Personnalisation du contenu, amélioration du service, sécurité et support.',
                  ),
                  _DocSection(
                    'Vos droits',
                    'Accès, rectification, effacement, opposition, limitation, portabilité.',
                  ),
                ],
              ),
            ),
          ),
          Divider(color: palette.border, height: 1),
          _ProfileRow(
            palette: palette,
            icon: Icons.tune_outlined,
            title: 'Gérer mes consentements',
            subtitle: 'Analytics, personnalisation',
            onTap: () => _openNestedSheet(
              context,
              _ConsentSheet(palette: palette),
            ),
          ),
          Divider(color: palette.border, height: 1),
          _DangerRow(
            palette: palette,
            icon: Icons.delete_outline,
            title: 'Supprimer mes données',
            subtitle: 'Effacement de votre compte',
            onTap: onDeleteData,
          ),
        ],
      ),
    );
  }

  void _openNestedSheet(BuildContext context, Widget sheet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => sheet,
    );
  }
}

class _ConsentSheet extends StatefulWidget {
  final _ProfilePalette palette;

  const _ConsentSheet({required this.palette});

  @override
  State<_ConsentSheet> createState() => _ConsentSheetState();
}

class _ConsentSheetState extends State<_ConsentSheet> {
  bool analytics = false;
  bool personalization = true;

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      palette: widget.palette,
      title: 'Gérer mes consentements',
      subtitle: 'Vous pouvez modifier vos choix à tout moment.',
      child: Column(
        children: [
          _SheetToggle(
            palette: widget.palette,
            label: 'Analytics',
            subtitle: 'Mesure d’audience',
            value: analytics,
            onChanged: (v) => setState(() => analytics = v),
          ),
          _SheetToggle(
            palette: widget.palette,
            label: 'Personnalisation',
            subtitle: 'Adapter le contenu à vos préférences',
            value: personalization,
            onChanged: (v) => setState(() => personalization = v),
          ),
          const SizedBox(height: 14),
          _SheetButton(
            palette: widget.palette,
            label: 'Enregistrer mes choix',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _SupportSheet extends StatelessWidget {
  final _ProfilePalette palette;

  const _SupportSheet({required this.palette});

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      palette: palette,
      title: 'Nous contacter',
      subtitle: 'Support, questions ou demande spécifique.',
      child: Column(
        children: [
          _SheetField(
            palette: palette,
            label: 'Sujet',
            placeholder: 'Ex : problème de connexion',
          ),
          _SheetField(
            palette: palette,
            label: 'Message',
            placeholder: 'Décrivez votre demande…',
            maxLines: 5,
          ),
          const SizedBox(height: 14),
          _SheetButton(
            palette: palette,
            label: 'Envoyer',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _ReportContentSheet extends StatelessWidget {
  final _ProfilePalette palette;

  const _ReportContentSheet({required this.palette});

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      palette: palette,
      title: 'Signaler une erreur / un contenu',
      subtitle:
          'Erreur factuelle, problème de source ou contenu inapproprié.',
      child: Column(
        children: [
          _SheetField(
            palette: palette,
            label: 'Article ou sujet',
            placeholder: 'Titre ou URL',
          ),
          _SheetField(
            palette: palette,
            label: 'Nature du problème',
            placeholder: 'Erreur factuelle, formulation, source…',
          ),
          _SheetField(
            palette: palette,
            label: 'Détails',
            placeholder: 'Décrivez le problème…',
            maxLines: 5,
          ),
          const SizedBox(height: 14),
          _SheetButton(
            palette: palette,
            label: 'Envoyer le signalement',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _DocumentSheet extends StatelessWidget {
  final _ProfilePalette palette;
  final String title;
  final List<_DocSection> sections;

  const _DocumentSheet({
    required this.palette,
    required this.title,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      palette: palette,
      title: title,
      child: Column(
        children: sections
            .map(
              (section) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: FigmaContract.body().copyWith(
                        color: palette.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      section.content,
                      style: FigmaContract.body().copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: palette.border, height: 1),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _DocSection {
  final String title;
  final String content;

  const _DocSection(this.title, this.content);
}

class _BaseSheet extends StatelessWidget {
  final _ProfilePalette palette;
  final String title;
  final String? subtitle;
  final Widget child;

  const _BaseSheet({
    required this.palette,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.35,
        maxChildSize: 0.94,
        expand: false,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: palette.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: FigmaContract.h2().copyWith(color: palette.textPrimary),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: FigmaContract.body().copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeRadioTile extends StatelessWidget {
  final _ProfilePalette palette;
  final String title;
  final AppThemePreference value;
  final AppThemePreference groupValue;
  final ValueChanged<AppThemePreference> onChanged;

  const _ThemeRadioTile({
    required this.palette,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<AppThemePreference>(
      activeColor: palette.primary,
      tileColor: palette.bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text(
        title,
        style: FigmaContract.body().copyWith(color: palette.textPrimary),
      ),
      value: value,
      groupValue: groupValue,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  final String userName;
  final _ProfilePalette palette;

  const _UserCard({
    required this.userName,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(FigmaContract.rLg),
        border: Border.all(color: palette.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: palette.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                style: FigmaContract.h2().copyWith(color: palette.onPrimary),
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
                  style:
                      FigmaContract.h2().copyWith(color: palette.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  'Votre fil est personnalisé selon vos sujets',
                  style: FigmaContract.caption().copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final _ProfilePalette palette;

  const _SectionHeader({
    required this.title,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 0, 8),
      child: Text(
        title.toUpperCase(),
        style: FigmaContract.caption().copyWith(
          color: palette.textSecondary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final _ProfilePalette palette;

  const _SettingsCard({
    required this.children,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(FigmaContract.rLg),
        border: Border.all(color: palette.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: children
            .expand((child) => [
                  child,
                  if (child != children.last)
                    Divider(color: palette.border, height: 1),
                ])
            .toList(),
      ),
    );
  }
}

class _LeadingIconBox extends StatelessWidget {
  final _ProfilePalette palette;
  final IconData icon;
  final bool danger;

  const _LeadingIconBox({
    required this.palette,
    required this.icon,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: danger ? palette.danger.withOpacity(0.10) : palette.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: danger
              ? palette.danger.withOpacity(0.22)
              : palette.border,
        ),
      ),
      child: Icon(
        icon,
        color: danger ? palette.danger : palette.textPrimary,
        size: 18,
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final _ProfilePalette palette;
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _ProfileRow({
    required this.palette,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: trailing == null ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            _LeadingIconBox(palette: palette, icon: icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FigmaContract.body().copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle!,
                      style: FigmaContract.caption().copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: palette.textSecondary,
                  size: 18,
                ),
          ],
        ),
      ),
    );
  }
}

class _DangerRow extends StatelessWidget {
  final _ProfilePalette palette;
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _DangerRow({
    required this.palette,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            _LeadingIconBox(
              palette: palette,
              icon: icon,
              danger: true,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FigmaContract.body().copyWith(
                      color: palette.danger,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle!,
                      style: FigmaContract.caption().copyWith(
                        color: palette.danger.withOpacity(0.78),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: palette.danger, size: 18),
          ],
        ),
      ),
    );
  }
}

class _SheetToggle extends StatelessWidget {
  final _ProfilePalette palette;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SheetToggle({
    required this.palette,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: FigmaContract.body().copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: FigmaContract.caption().copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final _ProfilePalette palette;
  final String label;
  final String placeholder;
  final bool obscure;
  final int maxLines;

  const _SheetField({
    required this.palette,
    required this.label,
    required this.placeholder,
    this.obscure = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        obscureText: obscure,
        maxLines: maxLines,
        style: FigmaContract.body().copyWith(color: palette.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          labelStyle: FigmaContract.caption().copyWith(
            color: palette.textSecondary,
          ),
          hintStyle: FigmaContract.caption().copyWith(
            color: palette.textSecondary.withOpacity(0.8),
          ),
          filled: true,
          fillColor: palette.bg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: palette.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: palette.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  final _ProfilePalette palette;
  final String label;
  final VoidCallback? onTap;

  const _SheetButton({
    required this.palette,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}

class _ProfilePalette {
  final Color bg;
  final Color surface;
  final Color border;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;
  final Color danger;
  final Color onPrimary;

  const _ProfilePalette({
    required this.bg,
    required this.surface,
    required this.border,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.danger,
    required this.onPrimary,
  });

  factory _ProfilePalette.of(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return _ProfilePalette(
      bg: theme.scaffoldBackgroundColor,
      surface: scheme.surface,
      border: theme.dividerColor,
      primary: scheme.primary,
      textPrimary: scheme.onSurface,
      textSecondary:
          isDark ? const Color(0xFFC6B8A8) : FigmaContract.textSecondary,
      danger: scheme.error,
      onPrimary: scheme.onPrimary,
    );
  }
}

class _ProfileEditSheet extends StatelessWidget {
  final _ProfilePalette palette;

  const _ProfileEditSheet({required this.palette});

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      palette: palette,
      title: 'Mon profil',
      subtitle: 'Modifier vos informations personnelles',
      child: Column(
        children: [
          _SheetField(
            palette: palette,
            label: 'Prénom',
            placeholder: 'Gabriel',
          ),
          _SheetField(
            palette: palette,
            label: 'Nom',
            placeholder: 'Sauvé',
          ),
          _SheetField(
            palette: palette,
            label: 'Email',
            placeholder: 'gabriel@incorrupto.fr',
          ),
          _SheetField(
            palette: palette,
            label: 'Mot de passe',
            placeholder: '••••••••',
            obscure: true,
          ),
          const SizedBox(height: 16),
          _SheetButton(
            palette: palette,
            label: 'Enregistrer',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}