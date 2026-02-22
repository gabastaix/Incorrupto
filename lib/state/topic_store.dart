import 'package:flutter/foundation.dart';

/// A "Topic" the user follows (shows on Home).
class FollowedTopic {
  final String id;          // unique
  final String title;       // e.g. "Nucléaire"
  final String category;    // e.g. "Transition énergétique"
  final String cadence;     // "Quotidien" | "Hebdomadaire" | "Mensuel"
  final String excerpt;     // short description (mock for now)

  const FollowedTopic({
    required this.id,
    required this.title,
    required this.category,
    required this.cadence,
    required this.excerpt,
  });

  FollowedTopic copyWith({String? cadence}) {
    return FollowedTopic(
      id: id,
      title: title,
      category: category,
      cadence: cadence ?? this.cadence,
      excerpt: excerpt,
    );
  }
}

/// Single shared store used by Home, Explorer, Sujets.
/// Later: this will be backed by your backend.
class TopicStore extends ChangeNotifier {
  TopicStore._();
  static final TopicStore instance = TopicStore._();

  final List<FollowedTopic> _followed = [];

  List<FollowedTopic> get followed => List.unmodifiable(_followed);

  bool isFollowed(String id) => _followed.any((t) => t.id == id);

  void add(FollowedTopic topic) {
    if (isFollowed(topic.id)) return;
    _followed.insert(0, topic);
    notifyListeners();
  }

  void remove(String id) {
    _followed.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void updateCadence(String id, String cadence) {
    final idx = _followed.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _followed[idx] = _followed[idx].copyWith(cadence: cadence);
    notifyListeners();
  }
}
