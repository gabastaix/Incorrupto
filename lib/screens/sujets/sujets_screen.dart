import 'package:flutter/material.dart';
import '../../design/figma_contract.dart';
import '../../state/topic_store.dart';

class SujetsScreen extends StatefulWidget {
  const SujetsScreen({super.key});

  @override
  State<SujetsScreen> createState() => _SujetsScreenState();
}

class _SujetsScreenState extends State<SujetsScreen> {
  final _controller = TextEditingController();
  String _cadence = 'Quotidien';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTopic() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final id = 'custom_${text.toLowerCase().replaceAll(' ', '_')}';

    TopicStore.instance.add(
      FollowedTopic(
        id: id,
        title: text,
        category: 'Sujet personnalisé',
        cadence: _cadence,
        excerpt: "Sujet ajouté par l’utilisateur. (Mock pour l’instant)",
      ),
    );

    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final border = FigmaContract.border;
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary = Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        title: Text('Sujets', style: FigmaContract.h1().copyWith(color: textPrimary)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ajouter un sujet', style: FigmaContract.body().copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),

              // Input + cadence
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(FigmaContract.rMd),
                  border: Border.all(color: border),
                ),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ex: Nucléaire, IA, Inflation...',
                        border: InputBorder.none,
                        hintStyle: FigmaContract.body().copyWith(color: textSecondary),
                      ),
                      onSubmitted: (_) => _addTopic(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Fréquence', style: FigmaContract.caption().copyWith(color: textSecondary, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        DropdownButton<String>(
                          value: _cadence,
                          underline: const SizedBox.shrink(),
                          items: const [
                            DropdownMenuItem(value: 'Quotidien', child: Text('Quotidien')),
                            DropdownMenuItem(value: 'Hebdomadaire', child: Text('Hebdomadaire')),
                            DropdownMenuItem(value: 'Mensuel', child: Text('Mensuel')),
                          ],
                          onChanged: (v) => setState(() => _cadence = v ?? 'Quotidien'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addTopic,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FigmaContract.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Ajouter', style: FigmaContract.body().copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Text('Mes sujets', style: FigmaContract.body().copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),

              Expanded(
                child: AnimatedBuilder(
                  animation: TopicStore.instance,
                  builder: (context, _) {
                    final topics = TopicStore.instance.followed;

                    if (topics.isEmpty) {
                      return Center(
                        child: Text(
                          "Aucun sujet pour l’instant.\nAjoute-en depuis Explorer ou ici.",
                          textAlign: TextAlign.center,
                          style: FigmaContract.body().copyWith(color: textSecondary),
                        ),
                      );
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: topics.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final t = topics[i];
                        return _FollowedTopicRow(topic: t);
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

class _FollowedTopicRow extends StatelessWidget {
  final FollowedTopic topic;
  const _FollowedTopicRow({required this.topic});

  @override
  Widget build(BuildContext context) {
    final border = FigmaContract.border;
    final surface = Theme.of(context).colorScheme.surface;
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary = Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(FigmaContract.rMd),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(topic.title, style: FigmaContract.body().copyWith(color: textPrimary, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(topic.category, style: FigmaContract.caption().copyWith(color: textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _CadenceChip(topic: topic),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => TopicStore.instance.remove(topic.id),
            icon: const Icon(Icons.close),
            color: textSecondary,
          ),
        ],
      ),
    );
  }
}

class _CadenceChip extends StatelessWidget {
  final FollowedTopic topic;
  const _CadenceChip({required this.topic});

  @override
  Widget build(BuildContext context) {
    final radius = FigmaContract.rSm;

    return PopupMenuButton<String>(
      onSelected: (v) => TopicStore.instance.updateCadence(topic.id, v),
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'Quotidien', child: Text('Quotidien')),
        PopupMenuItem(value: 'Hebdomadaire', child: Text('Hebdomadaire')),
        PopupMenuItem(value: 'Mensuel', child: Text('Mensuel')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: FigmaContract.border),
        ),
        child: Text(
          topic.cadence,
          style: FigmaContract.caption().copyWith(
            color: Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFC6B8A8)
    : FigmaContract.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}