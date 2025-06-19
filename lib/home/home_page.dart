import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/deck_editor.dart';
import '../screens/flashcard_viewer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flashcards Decks')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('decks').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['title'] ?? 'No title'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FlashcardViewer(deckId: doc.id))),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DeckEditor())),
        child: Icon(Icons.add),
      ),
    );
  }
}