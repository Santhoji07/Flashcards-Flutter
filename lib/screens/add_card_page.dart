import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCardPage extends StatefulWidget {
  final String deckId;
  const AddCardPage({super.key, required this.deckId});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final questionController = TextEditingController();
  final answerController = TextEditingController();

  void addCard() async {
    String question = questionController.text.trim();
    String answer = answerController.text.trim();

    if (question.isEmpty || answer.isEmpty) return;

    await FirebaseFirestore.instance.collection('decks').doc(widget.deckId).update({
      'cards': FieldValue.arrayUnion([
        {
          'question': question,
          'answer': answer,
          'known': false,
          'nextReview': DateTime.now().toIso8601String(),
        }
      ])
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Card')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addCard,
              child: const Text('Add Card'),
            ),
          ],
        ),
      ),
    );
  }
}
