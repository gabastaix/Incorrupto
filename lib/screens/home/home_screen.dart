// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../design/figma_contract.dart';
import '../../design/screen_map.dart';
import '../../state/topic_store.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bg = FigmaContract.bg;
    final border = FigmaContract.border;
    final textPrimary = FigmaContract.textPrimary;
    final textSecondary = FigmaContract.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour ${widget.userName.isEmpty ? 'ami' : widget.userName}',
                      style: FigmaContract.h1().copyWith(color: textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mercredi 28 janvier 2026',
                      style: FigmaContract.body().copyWith(color: textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: border,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "VOS SUJETS AUJOURD'HUI",
                      style: FigmaContract.caption().copyWith(
                        letterSpacing: 1.0,
                        color: textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      '${TopicStore.instance.followed.length} analyses',
                      style: FigmaContract.caption().copyWith(
                        color: FigmaContract.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: TopicStore.instance,
                builder: (context, _) {
                  final topics = TopicStore.instance.followed;

                  if (topics.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
                      child: Text(
                        "Ajoute des sujets depuis Explorer ou Sujets pour les voir ici.",
                        style: FigmaContract.body()
                            .copyWith(color: FigmaContract.textSecondary),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
                    child: Column(
                      children: [
                        for (int index = 0; index < topics.length; index++) ...[
                          _NewsCard(
                            data: _NewsCardData(
                              category: topics[index].category.toUpperCase(),
                              cadence: topics[index].cadence,
                              title: topics[index].title,
                              excerpt: topics[index].excerpt,
                            ),
                            surface: FigmaContract.surface,
                            border: FigmaContract.border,
                            textPrimary: FigmaContract.textPrimary,
                            textSecondary: FigmaContract.textSecondary,
                            onUnderstand: () {
                              Navigator.of(context)
                                  .pushNamed(ScreenMap.details);
                            },
                            // Native share: sends title + excerpt to WhatsApp,
                            // Instagram, or any app the user has installed.
                            onShare: () {
                              Share.share(
                                '${topics[index].title}\n\n'
                                '${topics[index].excerpt}',
                                subject: topics[index].title,
                              );
                            },
                          ),
                          if (index != topics.length - 1)
                            const SizedBox(height: 14),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsCardData {
  final String category;
  final String cadence;
  final String title;
  final String excerpt;

  const _NewsCardData({
    required this.category,
    required this.cadence,
    required this.title,
    required this.excerpt,
  });
}

class _NewsCard extends StatelessWidget {
  final _NewsCardData data;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onUnderstand;
  final VoidCallback onShare; // <-- NEW: triggers the native share sheet

  const _NewsCard({
    required this.data,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.onUnderstand,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final radius = (FigmaContract.rMd == 0) ? 18.0 : FigmaContract.rMd;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border),
        boxShadow: FigmaContract.cardShadow,
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category + cadence chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data.category,
                  style: FigmaContract.caption().copyWith(
                    color: textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              _Chip(text: data.cadence),
            ],
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            data.title,
            style: FigmaContract.body().copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w700,
              height: 1.25,
              fontSize: (FigmaContract.body().fontSize ?? 16) + 2,
            ),
          ),
          const SizedBox(height: 10),
          // Excerpt
          Text(
            data.excerpt,
            style: FigmaContract.body().copyWith(
              color: textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          // CTA row: "Comprendre le débat →"  +  Share button
          Row(
            children: [
              // Left: understand CTA
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onUnderstand,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 4),
                    child: Row(
                      children: [
                        Text(
                          'Comprendre le débat',
                          style: FigmaContract.body().copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.arrow_forward,
                            size: 18, color: textPrimary),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // Right: native Share button
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onShare,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 8),
                    child: Row(
                      children: [
                        Icon(Icons.share_outlined,
                            size: 18, color: textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          'Partager',
                          style: FigmaContract.caption().copyWith(
                            color: textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    final radius = (FigmaContract.rSm == 0) ? 12.0 : FigmaContract.rSm;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: FigmaContract.bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: FigmaContract.border),
      ),
      child: Text(
        text,
        style: FigmaContract.caption().copyWith(
          color: FigmaContract.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
