// lib/screens/messages/messages_screen.dart
import 'package:flutter/material.dart';
import '../../design/figma_contract.dart';
import '../../state/conversation_store.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _topTab = 0; // 0 = Conversations, 1 = Amis

  @override
  Widget build(BuildContext context) {
    final store = ConversationStore.instance;

    final bg = FigmaContract.bg;
    final surface = FigmaContract.surface;
    final border = FigmaContract.border;
    final textPrimary = FigmaContract.textPrimary;
    final textSecondary = FigmaContract.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Messages', style: FigmaContract.h1().copyWith(color: textPrimary)),
              const SizedBox(height: 14),

              // Top segmented control
              _TopSwitch(
                index: _topTab,
                onChanged: (i) => setState(() => _topTab = i),
              ),

              const SizedBox(height: 14),

              // Content
              Expanded(
                child: AnimatedBuilder(
                  animation: store,
                  builder: (context, _) {
                    if (_topTab == 0) {
                      // Conversations tab
                      final list = store.conversations;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${list.length} CONVERSATIONS',
                            style: FigmaContract.caption().copyWith(
                              color: textSecondary.withOpacity(0.7),
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: list.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, i) {
                                final c = list[i];
                                final last = c.messages.isNotEmpty ? c.messages.last : null;
                                final hasUnread = c.unreadCount > 0;

                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ChatScreen(conversationId: c.id),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(FigmaContract.rLg),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: surface,
                                      borderRadius: BorderRadius.circular(FigmaContract.rLg),
                                      border: Border.all(color: border),
                                    ),
                                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                                    child: Row(
                                      children: [
                                        // Avatar (tap -> profile)
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => FriendProfileScreen(conv: c),
                                              ),
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: FigmaContract.bg,
                                            child: Text(
                                              c.avatarLetter,
                                              style: FigmaContract.body().copyWith(
                                                color: textPrimary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Name + last message
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                c.name,
                                                style: FigmaContract.body().copyWith(
                                                  color: textPrimary,
                                                  fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                last?.text ?? 'Aucun message pour le moment',
                                                style: FigmaContract.caption().copyWith(
                                                  color: textSecondary,
                                                  fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        // Right side: time + unread dot
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              _formatTimeLabel(context, last?.time),
                                              style: FigmaContract.caption().copyWith(
                                                color: textSecondary,
                                                fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            if (hasUnread)
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: Colors.purple,
                                                  shape: BoxShape.circle,
                                                ),
                                              )
                                            else
                                              const SizedBox(height: 8),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }

                    // Friends tab
                    final friends = store.conversations; // mock: conversations = friends list
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar
                        Container(
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(FigmaContract.rMd),
                            border: Border.all(color: border),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Icon(Icons.search_outlined, color: textSecondary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Rechercher un ami',
                                  style: FigmaContract.body().copyWith(color: textSecondary),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Add friend button (mock)
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('TODO: Ajouter un ami (backend plus tard)')),
                            );
                          },
                          icon: const Icon(Icons.person_add_alt_1_outlined),
                          label: Text(
                            'Ajouter un ami',
                            style: FigmaContract.body().copyWith(fontWeight: FontWeight.w700),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textPrimary,
                            side: BorderSide(color: border, style: BorderStyle.solid),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(FigmaContract.rMd),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          '${friends.length} AMIS',
                          style: FigmaContract.caption().copyWith(
                            color: textSecondary.withOpacity(0.7),
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: friends.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, i) {
                              final c = friends[i];

                              return Container(
                                decoration: BoxDecoration(
                                  color: surface,
                                  borderRadius: BorderRadius.circular(FigmaContract.rLg),
                                  border: Border.all(color: border),
                                ),
                                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: FigmaContract.bg,
                                          child: Text(
                                            c.avatarLetter,
                                            style: FigmaContract.body().copyWith(
                                              color: textPrimary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                c.name,
                                                style: FigmaContract.body().copyWith(
                                                  color: textPrimary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                c.bio.isEmpty ? '—' : c.bio,
                                                style: FigmaContract.caption().copyWith(color: textSecondary),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    Text(
                                      "S'INTÉRESSE À",
                                      style: FigmaContract.caption().copyWith(
                                        color: textSecondary.withOpacity(0.75),
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: (c.interests.isEmpty ? const ['—'] : c.interests)
                                          .map(
                                            (tag) => Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: bg,
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(color: border),
                                              ),
                                              child: Text(
                                                tag,
                                                style: FigmaContract.caption().copyWith(color: textPrimary),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),

                                    const SizedBox(height: 12),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => FriendProfileScreen(conv: c),
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
                                              'Voir profil',
                                              style: FigmaContract.body().copyWith(color: textPrimary),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => ChatScreen(conversationId: c.id),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.chat_bubble_outline, size: 18),
                                            label: Text(
                                              'Message',
                                              style: FigmaContract.body().copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: FigmaContract.textPrimary,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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

class _TopSwitch extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _TopSwitch({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bg = FigmaContract.bg;
    final surface = FigmaContract.surface;
    final border = FigmaContract.border;
    final textPrimary = FigmaContract.textPrimary;
    final textSecondary = FigmaContract.textSecondary;

    Widget buildButton({
      required String label,
      required IconData icon,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected ? textPrimary : surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        offset: const Offset(0, 6),
                        blurRadius: 16,
                        color: const Color.fromARGB(255, 200, 124, 9).withOpacity(0.10),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: selected ? Colors.white : textSecondary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: FigmaContract.body().copyWith(
                    color: selected ? Colors.white : textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          buildButton(
            label: 'Conversations',
            icon: Icons.chat_bubble_outline,
            selected: index == 0,
            onTap: () => onChanged(0),
          ),
          const SizedBox(width: 8),
          buildButton(
            label: 'Amis',
            icon: Icons.group_outlined,
            selected: index == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String conversationId;
  const ChatScreen({required this.conversationId, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();

  Conversation get conv => ConversationStore.instance.getById(widget.conversationId)!;

  @override
  void initState() {
    super.initState();
    // Mark conversation as read when opened
    ConversationStore.instance.markRead(widget.conversationId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ConversationStore.instance.sendMessage(widget.conversationId, text);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final store = ConversationStore.instance;
    final bg = FigmaContract.bg;
    final surface = FigmaContract.surface;
    final border = FigmaContract.border;
    final textPrimary = FigmaContract.textPrimary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: bg,
              child: Text(
                conv.avatarLetter,
                style: FigmaContract.body().copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                conv.name,
                style: FigmaContract.body().copyWith(color: textPrimary, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: store,
                builder: (context, _) {
                  final msgs = conv.messages;
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    itemCount: msgs.length,
                    itemBuilder: (context, i) {
                      final m = msgs[i];
                      final isMine = m.mine;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 280),
                              decoration: BoxDecoration(
                                color: isMine ? FigmaContract.textPrimary : surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: border),
                              ),
                              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                              child: Text(
                                m.text,
                                style: FigmaContract.body().copyWith(
                                  color: isMine ? Colors.white : textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Composer
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Message...',
                          border: InputBorder.none,
                        ),
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _send,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: FigmaContract.textPrimary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendProfileScreen extends StatelessWidget {
  final Conversation conv;
  const FriendProfileScreen({required this.conv, super.key});

  @override
  Widget build(BuildContext context) {
    final bg = FigmaContract.bg;
    final surface = FigmaContract.surface;
    final border = FigmaContract.border;
    final textPrimary = FigmaContract.textPrimary;
    final textSecondary = FigmaContract.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profil',
          style: FigmaContract.body().copyWith(color: textPrimary, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(FigmaContract.rLg),
              border: Border.all(color: border),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: bg,
                      child: Text(
                        conv.avatarLetter,
                        style: FigmaContract.body().copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conv.name,
                            style: FigmaContract.body().copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (conv.bio.isNotEmpty)
                            Text(
                              conv.bio,
                              style: FigmaContract.caption().copyWith(color: textSecondary),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (conv.interests.isNotEmpty) ...[
                  Text(
                    "S'INTÉRESSE À",
                    style: FigmaContract.caption().copyWith(
                      color: textSecondary.withOpacity(0.75),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: conv.interests
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: border),
                            ),
                            child: Text(
                              tag,
                              style: FigmaContract.caption().copyWith(color: textPrimary),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],

                const Spacer(),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Fermer', style: FigmaContract.body().copyWith(color: textSecondary)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => ChatScreen(conversationId: conv.id)),
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_outline, size: 18),
                        label: Text(
                          'Message',
                          style: FigmaContract.body().copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FigmaContract.textPrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatTimeLabel(BuildContext context, DateTime? time) {
  if (time == null) return '';
  final now = DateTime.now();

  final diff = now.difference(time);
  if (diff.inDays >= 2) return '${diff.inDays} jours';
  if (diff.inDays == 1) return 'Hier';
  if (diff.inHours >= 1) return 'Il y a ${diff.inHours}h';
  if (diff.inMinutes >= 1) return 'Il y a ${diff.inMinutes}min';
  return 'À l’instant';
}
