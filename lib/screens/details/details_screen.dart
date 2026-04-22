// lib/screens/details/details_screen.dart
import 'package:flutter/material.dart';
import '../../design/figma_contract.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String summary;
  final List<Viewpoint> viewpoints;
  final List<ArticleSource> sources;

  const DetailsScreen({
    super.key,
    required this.title,
    required this.summary,
    required this.viewpoints,
    required this.sources,
  });

  factory DetailsScreen.demo({Key? key}) {
    return DetailsScreen(
      key: key,
      title: 'Analyse démonstration : Réforme des retraites',
      summary:
          'Voici les faits essentiels et confirmés publiés par des sources '
          'crédibles. L\'objectif est d\'expliquer ce qui s\'est passé sans juger.',
      viewpoints: const [
        Viewpoint(
          label: 'Les syndicats',
          summary:
              'Farouchement opposés à la réforme, ils mettent en avant la '
              'pénibilité des métiers et l\'injustice pour les travailleurs '
              'manuels contraints de travailler deux ans de plus.',
        ),
        Viewpoint(
          label: 'Le gouvernement',
          summary:
              'Défend la nécessité économique de la réforme face au '
              'vieillissement démographique, en insistant sur la soutenabilité '
              'du système de retraites à long terme.',
        ),
        Viewpoint(
          label: 'Les économistes',
          summary:
              'Partagés : certains valident les projections officielles, '
              'd\'autres proposent des alternatives (taxation du capital, '
              'retraite à points) et contestent les hypothèses de croissance.',
        ),
        Viewpoint(
          label: 'L\'opinion publique',
          summary:
              'Une majorité de Français s\'est déclarée opposée à la réforme '
              'selon les sondages, avec une mobilisation sociale inédite '
              'depuis des décennies.',
        ),
      ],
      sources: const [
        ArticleSource(
            title: 'Le Monde — article', url: 'https://example.com/article1'),
        ArticleSource(
            title: 'Libération — dossier',
            url: 'https://example.com/article2'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaContract.bg,
      appBar: AppBar(
        backgroundColor: FigmaContract.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: FigmaContract.textPrimary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Comprendre le débat',
          style: FigmaContract.body().copyWith(
            color: FigmaContract.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _DetailsBody(
          title: title,
          summary: summary,
          viewpoints: viewpoints,
          sources: sources,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body
// ─────────────────────────────────────────────────────────────────────────────

class _DetailsBody extends StatefulWidget {
  final String title;
  final String summary;
  final List<Viewpoint> viewpoints;
  final List<ArticleSource> sources;

  const _DetailsBody({
    required this.title,
    required this.summary,
    required this.viewpoints,
    required this.sources,
  });

  @override
  State<_DetailsBody> createState() => _DetailsBodyState();
}

class _DetailsBodyState extends State<_DetailsBody> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = FigmaContract.textPrimary;
    final textSecondary = FigmaContract.textSecondary;
    final total = widget.viewpoints.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: FigmaContract.h2().copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _SummaryCard(summary: widget.summary, sources: widget.sources),
              const SizedBox(height: 28),

              // Section header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: FigmaContract.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Les perspectives',
                        style: FigmaContract.h2().copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: FigmaContract.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentPage + 1} / $total',
                      style: FigmaContract.caption().copyWith(
                        color: FigmaContract.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Swipe pour voir chaque point de vue →',
                style: FigmaContract.caption().copyWith(color: textSecondary),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),

        // Carousel
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: total,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 20 : 8,
                  right: i == total - 1 ? 20 : 8,
                ),
                child: _ViewpointCard(
                  viewpoint: widget.viewpoints[i],
                  index: i,
                  isActive: i == _currentPage,
                ),
              );
            },
          ),
        ),

        // Dot indicators
        const SizedBox(height: 16),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(total, (i) {
              final active = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: active
                      ? FigmaContract.primary
                      : FigmaContract.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),

        const Spacer(),

        // Footer CTA
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: FigmaContract.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 0,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ouvrir la source')),
                );
              },
              child: Text(
                'Voir la source originale',
                style: FigmaContract.body().copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Perspective card
//
// Palette "Terres chaudes" — tous les tons viennent de la même famille :
// ambre · terracotta · ardoise bleue · ocre · sauge · prune poussiéreux.
// Assez distincts pour se différencier, assez proches pour cohabiter.
// ─────────────────────────────────────────────────────────────────────────────

const List<Color> _perspectiveAccents = [
  Color(0xFFB8622A), // ambre (= primary)
  Color(0xFF7A4E3E), // terracotta foncé
  Color(0xFF4C6B8A), // ardoise bleue
  Color(0xFF8B6914), // ocre doré
  Color(0xFF4A6741), // sauge profond
  Color(0xFF6B4E7A), // prune poussiéreux
];

class _ViewpointCard extends StatelessWidget {
  final Viewpoint viewpoint;
  final int index;
  final bool isActive;

  const _ViewpointCard({
    required this.viewpoint,
    required this.index,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _perspectiveAccents[index % _perspectiveAccents.length];

    return AnimatedScale(
      scale: isActive ? 1.0 : 0.95,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: isActive ? 1.0 : 0.65,
        duration: const Duration(milliseconds: 220),
        child: Container(
          decoration: BoxDecoration(
            color: FigmaContract.surface,
            borderRadius: BorderRadius.circular(FigmaContract.rMd),
            border: Border.all(
              color: isActive
                  ? accent.withOpacity(0.4)
                  : FigmaContract.border,
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: isActive ? FigmaContract.cardShadow : [],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left colour bar
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.10),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: FigmaContract.caption().copyWith(
                                    color: accent,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                viewpoint.label,
                                style: FigmaContract.body().copyWith(
                                  color: FigmaContract.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Text(
                              viewpoint.summary,
                              style: FigmaContract.body().copyWith(
                                color: FigmaContract.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary card
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String summary;
  final List<ArticleSource> sources;

  const _SummaryCard({required this.summary, required this.sources});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FigmaContract.primaryLight,
        borderRadius: BorderRadius.circular(FigmaContract.rMd),
        border: Border.all(
          color: FigmaContract.primary.withOpacity(0.18),
        ),
        boxShadow: FigmaContract.cardShadow,
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined,
                  size: 15, color: FigmaContract.primary),
              const SizedBox(width: 6),
              Text(
                'Faits & résumé',
                style: FigmaContract.caption().copyWith(
                  color: FigmaContract.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            summary,
            style: FigmaContract.body().copyWith(
              color: FigmaContract.textPrimary,
              height: 1.5,
            ),
          ),
          if (sources.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(
                color: FigmaContract.primary.withOpacity(0.15), height: 1),
            const SizedBox(height: 10),
            ...sources.map((s) => _SourceRow(source: s)),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Source row
// ─────────────────────────────────────────────────────────────────────────────

class _SourceRow extends StatelessWidget {
  final ArticleSource source;
  const _SourceRow({required this.source});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ouvrir : ${source.title}')));
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(Icons.article_outlined,
                size: 16, color: FigmaContract.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                source.title,
                style: FigmaContract.body()
                    .copyWith(color: FigmaContract.textPrimary),
              ),
            ),
            Icon(Icons.open_in_new,
                size: 14, color: FigmaContract.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data classes
// ─────────────────────────────────────────────────────────────────────────────

class Viewpoint {
  final String label;
  final String summary;
  const Viewpoint({required this.label, required this.summary});
}

class ArticleSource {
  final String title;
  final String url;
  const ArticleSource({required this.title, required this.url});
}
