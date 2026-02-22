// lib/screens/details/details_screen.dart
import 'package:flutter/material.dart';
import '../../design/figma_contract.dart';

class DetailsScreen extends StatelessWidget {
  // Optional: pass in data using arguments via Navigator
  final String title;
  final String summary;
  final List<_Viewpoint> viewpoints;
  final List<_Source> sources;

  const DetailsScreen({
    super.key,
    required this.title,
    required this.summary,
    required this.viewpoints,
    required this.sources,
  });

  // A helper factory for a quick demo when navigating without real data.
 factory DetailsScreen.demo({Key? key}) {
    return DetailsScreen(
      title: 'Analyse démonstration : Réforme des retraites',
      summary:
          "Résumé neutre : Voici les faits essentiels et confirmés publiés par des sources crédibles. "
          "L’objectif est d’expliquer ce qui s’est passé sans juger.",
      viewpoints: const [
        _Viewpoint(
          label: 'La droite',
          summary:
              'Argument principal: Favorise la compétitivité, propose indexation par points, insiste sur la soutenabilité.',
        ),
        _Viewpoint(
          label: 'La gauche',
          summary:
              'Argument principal: Met l’accent sur la protection sociale et la justice intergénérationnelle.',
        ),
        _Viewpoint(
          label: 'Les experts',
          summary:
              'Argument principal: Analyse technique sur financement, projections démographiques et alternatives.',
        ),
      ],
      sources: const [
        _Source(title: 'Le Monde — article', url: 'https://example.com/article1'),
        _Source(title: 'Libération — dossier', url: 'https://example.com/article2'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = FigmaContract.bg;
    final surface = FigmaContract.surface;
    final textPrimary = FigmaContract.textPrimary;
    final textSecondary = FigmaContract.textSecondary;
    final border = FigmaContract.border;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: textPrimary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Comprendre le débat',
          style: FigmaContract.body().copyWith(color: textPrimary, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
          child: Column(
            children: [
              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: FigmaContract.h2().copyWith(color: textPrimary, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),

              // Summary card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(FigmaContract.rMd),
                  border: Border.all(color: border),
                  boxShadow: FigmaContract.cardShadow,
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Faits & résumé',
                      style: FigmaContract.caption().copyWith(color: textSecondary, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      summary,
                      style: FigmaContract.body().copyWith(color: textPrimary, height: 1.45),
                    ),
                    const SizedBox(height: 8),
                    // small source row
                    Row(
                      children: [
                        Icon(Icons.link, size: 16, color: FigmaContract.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Sources vérifiables',
                          style: FigmaContract.caption().copyWith(color: FigmaContract.primary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Tabs: Résumé / Points de vue
              Expanded(
                child: _DetailsTabs(
                  viewpoints: viewpoints,
                  sources: sources,
                ),
              ),

              // Footer CTA row
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FigmaContract.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: Row(
                  children: [
                    _SmallActionButton(
                      icon: Icons.bookmark_border,
                      label: 'Sauvegarder',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sauvegardé')));
                      },
                    ),
                    const SizedBox(width: 10),
                    _SmallActionButton(
                      icon: Icons.share_outlined,
                      label: 'Partager',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Partager')));
                      },
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FigmaContract.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // TODO: open first source url / full article
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ouvrir la source')));
                      },
                      child: Text('Voir la source', style: FigmaContract.body().copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tabs widget with summary + viewpoints list + sources
class _DetailsTabs extends StatefulWidget {
  final List<_Viewpoint> viewpoints;
  final List<_Source> sources;

  const _DetailsTabs({required this.viewpoints, required this.sources});

  @override
  State<_DetailsTabs> createState() => _DetailsTabsState();
}

class _DetailsTabsState extends State<_DetailsTabs> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = FigmaContract.textPrimary;
    final textSecondary = FigmaContract.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          labelColor: textPrimary,
          unselectedLabelColor: textSecondary,
          indicatorColor: FigmaContract.primary,
          labelStyle: FigmaContract.body().copyWith(fontWeight: FontWeight.w700),
          unselectedLabelStyle: FigmaContract.body(),
          tabs: const [
            Tab(text: 'Résumé'),
            Tab(text: 'Points de vue'),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Résumé: show a longer neutral summary + sources
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // longer neutral summary (we reuse the demo summary for now)
                      Text(
                        'Résumé détaillé',
                        style: FigmaContract.h2().copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.viewpoints.map((v) => v.summary).join('\n\n'),
                        style: FigmaContract.body().copyWith(color: textSecondary, height: 1.45),
                      ),
                      const SizedBox(height: 18),
                      Text('Sources', style: FigmaContract.caption().copyWith(color: textSecondary, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      ...widget.sources.map((s) => _SourceRow(source: s)).toList(),
                    ],
                  ),
                ),
              ),

              // Points de vue: expand/collapse viewpoints
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: widget.viewpoints.map((v) => _ViewpointCard(viewpoint: v)).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Viewpoint {
  final String label;
  final String summary;

  const _Viewpoint({required this.label, required this.summary});
}

class _Source {
  final String title;
  final String url;

  const _Source({required this.title, required this.url});
}

class _ViewpointCard extends StatefulWidget {
  final _Viewpoint viewpoint;

  const _ViewpointCard({required this.viewpoint});

  @override
  State<_ViewpointCard> createState() => _ViewpointCardState();
}

class _ViewpointCardState extends State<_ViewpointCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final border = FigmaContract.border;
    final surface = FigmaContract.surface;
    final textPrimary = FigmaContract.textPrimary;
    final textSecondary = FigmaContract.textSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(FigmaContract.rSm),
        border: Border.all(color: border),
        boxShadow: FigmaContract.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _open = !_open),
          borderRadius: BorderRadius.circular(FigmaContract.rSm),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.viewpoint.label,
                        style: FigmaContract.body().copyWith(color: textPrimary, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Icon(_open ? Icons.expand_less : Icons.expand_more, color: textSecondary),
                  ],
                ),
                if (_open) ...[
                  const SizedBox(height: 8),
                  Text(widget.viewpoint.summary, style: FigmaContract.body().copyWith(color: textSecondary, height: 1.45)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  final _Source source;

  const _SourceRow({required this.source});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: open url with url_launcher
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ouvrir: ${source.title}')));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(Icons.article_outlined, size: 18, color: FigmaContract.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                source.title,
                style: FigmaContract.body().copyWith(color: FigmaContract.textPrimary),
              ),
            ),
            Icon(Icons.open_in_new, size: 16, color: FigmaContract.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SmallActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            children: [
              Icon(icon, size: 18, color: FigmaContract.textPrimary),
              const SizedBox(width: 8),
              Text(label, style: FigmaContract.caption().copyWith(color: FigmaContract.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}
