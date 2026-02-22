// lib/screens/messages/share.dart
import 'package:flutter/material.dart';
import '../../design/figma_contract.dart';
import '../../state/conversation_store.dart';

/// A reusable helper: open a modal bottom sheet to pick a friend and send an article.
/// Call from any screen: showShareArticleModal(context, title, excerpt);
Future<void> showShareArticleModal(BuildContext context, String title, String excerpt) {
  final store = ConversationStore.instance;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (ctx) {
      final textController = TextEditingController(text: "$title\n\n$excerpt");
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  Text('Partager vers', style: FigmaContract.h2().copyWith(color: FigmaContract.textPrimary)),
                  Spacer(),
                  IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
                ]),
                const SizedBox(height: 8),

                // Friends list (from conversations)
                SizedBox(
                  height: 90,
                  child: AnimatedBuilder(
                    animation: store,
                    builder: (_, __) {
                      final list = store.conversations;
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          if (i == list.length) {
                            // new friend quick-add
                            return InkWell(
                              onTap: () {
                                // show a dialog to enter new friend name then send
                                showDialog(
                                  context: ctx,
                                  builder: (dctx) {
                                    final nameCtrl = TextEditingController();
                                    return AlertDialog(
                                      title: Text('Nouveau contact'),
                                      content: TextField(controller: nameCtrl, decoration: InputDecoration(hintText: 'Nom')),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.of(dctx).pop(), child: Text('Annuler')),
                                        TextButton(onPressed: () {
                                          final nm = nameCtrl.text.trim();
                                          if (nm.isNotEmpty) {
                                            store.createConversationAndSend(nm, textController.text.trim());
                                            Navigator.of(dctx).pop(); // close dialog
                                            Navigator.of(ctx).pop(); // close sheet
                                          }
                                        }, child: Text('Créer & envoyer')),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 70,
                                decoration: BoxDecoration(
                                  color: FigmaContract.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: FigmaContract.border),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(child: Icon(Icons.add), radius: 18, backgroundColor: FigmaContract.bg),
                                    SizedBox(height: 8),
                                    Text('Nouveau', style: FigmaContract.caption()),
                                  ],
                                ),
                              ),
                            );
                          }

                          final c = list[i];
                          return GestureDetector(
                            onTap: () {
                              // send immediately and close
                              store.sendMessage(c.id, textController.text.trim());
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Envoyé à ${c.name}')));
                            },
                            child: Container(
                              width: 90,
                              decoration: BoxDecoration(
                                color: FigmaContract.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: FigmaContract.border),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(child: Text(c.avatarLetter), radius: 20, backgroundColor: FigmaContract.bg),
                                  const SizedBox(height: 8),
                                  Text(c.name, overflow: TextOverflow.ellipsis, style: FigmaContract.caption()),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),
                // message preview + send button
                TextField(
                  controller: textController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: FigmaContract.border)),
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // default: send to first conversation if exists
                          final list = store.conversations;
                          if (list.isNotEmpty) {
                            store.sendMessage(list.first.id, textController.text.trim());
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Envoyé à ${list.first.name}')));
                          } else {
                            // create a simple conversation
                            store.createConversationAndSend('Contact', textController.text.trim());
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Envoyé')));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FigmaContract.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('Envoyer', style: FigmaContract.body().copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
