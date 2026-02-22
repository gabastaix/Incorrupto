// lib/screens/explorer/explorer_screen.dart
import 'package:flutter/material.dart';
import '../../design/figma_contract.dart';
import '../../design/screen_map.dart';
import '../../state/topic_store.dart';


class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({Key? key}) : super(key: key);

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  String _query = '';
  final List<String> _chips = const [
  'Pour vous',
  'Breaking',
  'Politique',
  'Climat',
  'Tech',
  'Économie',
  'International',
  'Société',
  'Santé',
  'Culture',
];

String _selectedChip = 'Pour vous';


  // Mock topics (will be replaced by backend later)
  late final Map<String, List<_ExplorerTopic>> _itemsByChip = {
  'Pour vous': List.generate(8, (i) {
    return _ExplorerTopic(
      id: 'for_you_${i + 1}',
      title: 'Pour vous ${i + 1} — sujet recommandé',
      excerpt: 'Sélection personnalisée basée sur vos intérêts. (Mock)',
      tag: 'Pour vous',
    );
  }),
  'Breaking': List.generate(8, (i) {
    return _ExplorerTopic(
      id: 'breaking_${i + 1}',
      title: 'Breaking ${i + 1} — info urgente',
      excerpt: 'Actualité en cours / mise à jour en temps réel. (Mock)',
      tag: 'Breaking',
    );
  }),
  'Politique': List.generate(8, (i) {
    return _ExplorerTopic(
      id: 'politique_${i + 1}',
      title: 'Politique ${i + 1} — titre attractif',
      excerpt: 'Court résumé politique ${i + 1}. (Mock)',
      tag: 'Politique',
    );
  }),
  'Climat': List.generate(8, (i) {
    return _ExplorerTopic(
      id: 'climat_${i + 1}',
      title: 'Climat ${i + 1} — titre attractif',
      excerpt: 'Court résumé climat ${i + 1}. (Mock)',
      tag: 'Climat',
    );
  }),
  'Tech': List.generate(8, (i) {
    return _ExplorerTopic(
      id: 'tech_${i + 1}',
      title: 'Tech ${i + 1} — titre attractif',
      excerpt: 'Court résumé tech ${i + 1}. (Mock)',
      tag: 'Tech',
    );
  }),
  'Économie': List.generate(8, (i) {
    return _ExplorerTopic(
      id: 'eco_${i + 1}',
      title: 'Économie ${i + 1} — titre attractif',
      excerpt: 'Court résumé économie ${i + 1}. (Mock)',
      tag: 'Économie',
    );
  }),

  // new themes
  'International': List.generate(8, (i) {
    return _ExplorerTopic(
      id: 'intl_${i + 1}',
      title: 'International ${i + 1} — titre attractif',
      excerpt: 'Court résumé international ${i + 1}. (Mock)',
      tag: 'International',
    );
  }),
  'Société': List.generate(8, (i) {
    return _ExplorerTopic(
      id: 'societe_${i + 1}',
      title: 'Société ${i + 1} — titre attractif',
      excerpt: 'Court résumé société ${i + 1}. (Mock)',
      tag: 'Société',
    );
  }),
  'Santé': List.generate(8, (i) {
    return _ExplorerTopic(
      id: 'sante_${i + 1}',
      title: 'Santé ${i + 1} — titre attractif',
      excerpt: 'Court résumé santé ${i + 1}. (Mock)',
      tag: 'Santé',
    );
  }),
  'Culture': List.generate(8, (i) {
    return _ExplorerTopic(
      id: 'culture_${i + 1}',
      title: 'Culture ${i + 1} — titre attractif',
      excerpt: 'Court résumé culture ${i + 1}. (Mock)',
      tag: 'Culture',
    );
  }),
};

  List<_ExplorerTopic> get filteredItems {
  final q = _query.trim().toLowerCase();
  final base = _itemsByChip[_selectedChip] ?? const <_ExplorerTopic>[];

  if (q.isEmpty) return base;

  return base.where((t) {
    return t.title.toLowerCase().contains(q) ||
        t.excerpt.toLowerCase().contains(q);
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    final bg = FigmaContract.bg;
    final border = FigmaContract.border;
    final textPrimary = FigmaContract.textPrimary;
    final textSecondary = FigmaContract.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text('Explorer', style: FigmaContract.h1().copyWith(color: textPrimary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
          child: Column(
            children: [
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: FigmaContract.surface,
                  borderRadius: BorderRadius.circular(FigmaContract.rMd),
                  border: Border.all(color: border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.search_outlined),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher un sujet, mot-clé...',
                          border: InputBorder.none,
                          hintStyle: FigmaContract.body().copyWith(color: textSecondary),
                        ),
                        onChanged: (v) => setState(() => _query = v),
                      ),
                    ),
                    if (_query.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() => _query = ''),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.clear, size: 20),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Chips row
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _chips.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final chip = _chips[i];
                    final selected = chip == _selectedChip;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedChip = chip),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? FigmaContract.primary.withOpacity(0.12) : FigmaContract.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: selected ? FigmaContract.primary : border),
                        ),
                        child: Text(
                          chip,
                          style: FigmaContract.body().copyWith(
                            color: selected ? FigmaContract.primary : textSecondary,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Results header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${filteredItems.length} résultats', style: FigmaContract.caption().copyWith(color: textSecondary)),
                  Text('Trier', style: FigmaContract.caption().copyWith(color: FigmaContract.primary)),
                ],
              ),

              const SizedBox(height: 8),

              // List
              Expanded(
                child: filteredItems.isEmpty
                    ? Center(child: Text('Aucun résultat', style: FigmaContract.body().copyWith(color: textSecondary)))
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, idx) {
                          final t = filteredItems[idx];
                          return _ExplorerCard(
                            topic: t,
                            onOpen: () {
                              // For now, open the details demo but pass title/summary via arguments later if you want.
                              Navigator.of(context).pushNamed(ScreenMap.details, arguments: {
                                'title': t.title,
                                'summary': t.excerpt,
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExplorerTopic {
  final String id;
  final String title;
  final String excerpt;
  final String tag;

  _ExplorerTopic({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.tag,
  });
}

class _ExplorerCard extends StatelessWidget {
  final _ExplorerTopic topic;
  final VoidCallback onOpen;

  const _ExplorerCard({required this.topic, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final store = TopicStore.instance;
    final border = FigmaContract.border;
    final surface = FigmaContract.surface;
    final textPrimary = FigmaContract.textPrimary;
    final textSecondary = FigmaContract.textSecondary;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final followed = store.isFollowed(topic.id);

        return Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(FigmaContract.rMd),
            border: Border.all(color: border),
            boxShadow: FigmaContract.cardShadow,
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // tag + add button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      topic.tag.toUpperCase(),
                      style: FigmaContract.caption().copyWith(
                        color: textSecondary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (followed) {
                        store.remove(topic.id);
                      } else {
                        store.add(
                          FollowedTopic(
                            id: topic.id,
                            title: topic.title,
                            category: topic.tag,
                            cadence: 'Quotidien', // default
                            excerpt: topic.excerpt,
                          ),
                        );
                      }
                    },
                    child: Text(
                      followed ? 'Ajouté' : 'Ajouter',
                      style: FigmaContract.body().copyWith(
                        color: followed
                            ? FigmaContract.textSecondary
                            : FigmaContract.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                topic.title,
                style: FigmaContract.body().copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                topic.excerpt,
                style: FigmaContract.body().copyWith(
                  color: textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onOpen,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Voir',
                        style: FigmaContract.body().copyWith(
                          color: FigmaContract.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 16, color: FigmaContract.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
