import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlashcardViewer extends StatefulWidget {
  final String deckId;
  FlashcardViewer({required this.deckId});

  @override
  _FlashcardViewerState createState() => _FlashcardViewerState();
}

class _FlashcardViewerState extends State<FlashcardViewer> {
  int currentIndex = 0;
  List cards = [];

  @override
  void initState() {
    super.initState();
    fetchDeck();
  }

  void fetchDeck() async {
    var doc = await FirebaseFirestore.instance.collection('decks').doc(widget.deckId).get();
    setState(() {
      cards = List.from(doc['cards']);
      cards.shuffle();  // Shuffle cards
    });
  }

  void markAsKnown() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Marked as known")));
    nextCard();
  }

  void markAsUnknown() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Marked as unknown")));
    nextCard();
  }

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % cards.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) return Center(child: CircularProgressIndicator());
    var card = cards[currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text("Flashcards")),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(card['question'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text(card['answer'], style: TextStyle(fontSize: 20)),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.check),
                      label: Text("Known"),
                      onPressed: markAsKnown,
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.clear),
                      label: Text("Unknown"),
                      onPressed: markAsUnknown,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}