// lib/state/conversation_store.dart
import 'package:flutter/foundation.dart';

class Message {
  final String id;
  final String text;
  final DateTime time;
  final bool mine;

  Message({
    required this.id,
    required this.text,
    required this.time,
    required this.mine,
  });
}

class Conversation {
  final String id;
  final String name;
  final String avatarLetter;

  /// Short description / bio for the friend
  final String bio;

  /// Big themes the friend is interested in
  final List<String> interests;

  /// How many unread messages there are in this conversation (mock for now)
  int unreadCount;

  final List<Message> messages;

  Conversation({
    required this.id,
    required this.name,
    required this.avatarLetter,
    this.bio = '',
    this.interests = const [],
    this.unreadCount = 0,
    List<Message>? messages,
  }) : messages = messages ?? [];
}

class ConversationStore extends ChangeNotifier {
  ConversationStore._();
  static final ConversationStore instance = ConversationStore._();

  final List<Conversation> _conversations = [
    Conversation(
      id: 'alice',
      name: 'Alice',
      avatarLetter: 'A',
      messages: [
        Message(id: 'm1', text: "Salut, as-tu vu l'article sur l'énergie ?", time: DateTime.now().subtract(Duration(hours: 5)), mine: false),
        Message(id: 'm2', text: "Oui intéressant — je t'envoie le résumé.", time: DateTime.now().subtract(Duration(hours: 4, minutes:50)), mine: true),
      ],
    ),
    Conversation(
      id: 'ben',
      name: 'Ben',
      avatarLetter: 'B',
      messages: [
        Message(id: 'm3', text: "Tu suis toujours la réforme ?", time: DateTime.now().subtract(Duration(days: 1)), mine: false),
      ],
    ),
    Conversation(
      id: 'claire',
      name: 'Claire',
      avatarLetter: 'C',
    ),
  ];

  List<Conversation> get conversations => List.unmodifiable(_conversations);

  Conversation? getById(String id) {
  if (_conversations.isEmpty) return null;

  return _conversations.firstWhere(
    (c) => c.id == id,
    orElse: () => _conversations.first,
  );
}

void markRead(String id) {
  final conv = _conversations.firstWhere(
    (c) => c.id == id,
    orElse: () => _conversations.first,
  );
  conv.unreadCount = 0;
  notifyListeners();
}

  void sendMessage(String conversationId, String text) {
    final conv = _conversations.firstWhere((c) => c.id == conversationId, orElse: () => _conversations.first);
    conv.messages.add(
      Message(id: DateTime.now().millisecondsSinceEpoch.toString(), text: text, time: DateTime.now(), mine: true),
    );
    notifyListeners();
  }

  void sendToConversationObject(Conversation conv, String text) {
    conv.messages.add(Message(id: DateTime.now().millisecondsSinceEpoch.toString(), text: text, time: DateTime.now(), mine: true));
    notifyListeners();
  }

  void createConversationAndSend(String name, String text) {
    final id = 'c_${DateTime.now().millisecondsSinceEpoch}';
    final conv = Conversation(id: id, name: name, avatarLetter: name.isNotEmpty ? name[0].toUpperCase() : '?', messages: []);
    _conversations.insert(0, conv);
    sendToConversationObject(conv, text);
    notifyListeners();
  }

  // For quick "share" convenience: return shallow copy of conversations (IDs + names)
}
