import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'flashcard_viewer.dart';

class DeckEditor extends StatefulWidget {
  @override
  _DeckEditorState createState() => _DeckEditorState();
}

class _DeckEditorState extends State<DeckEditor> {
  final _deckNameController = TextEditingController();
  List<Map<String, String>> cards = [];

  void addCard() {
    cards.add({"question": "", "answer": ""});
    setState(() {});
  }

  void saveDeck() async {
    await FirebaseFirestore.instance.collection('decks').add({
      'title': _deckNameController.text,
      'cards': cards,
      'createdAt': Timestamp.now(),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Deck")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(controller: _deckNameController, decoration: InputDecoration(labelText: "Deck Name")),
          SizedBox(height: 10),
          ...cards.map((card) {
            int index = cards.indexOf(card);
            return Card(
              child: ListTile(
                title: TextField(
                  onChanged: (val) => card['question'] = val,
                  decoration: InputDecoration(labelText: "Question"),
                ),
                subtitle: TextField(
                  onChanged: (val) => card['answer'] = val,
                  decoration: InputDecoration(labelText: "Answer"),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    cards.removeAt(index);
                    setState(() {});
                  },
                ),
              ),
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: addCard, child: Text("Add Card")),
              ElevatedButton(onPressed: saveDeck, child: Text("Save Deck")),
            ],
          ),
        ],
      ),
    );
  }
}