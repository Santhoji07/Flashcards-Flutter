import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_card_page.dart'; // You'll need to create this file

class FlashcardViewer extends StatefulWidget {
  final String deckId;
  FlashcardViewer({required this.deckId});

  @override
  _FlashcardViewerState createState() => _FlashcardViewerState();
}

class _FlashcardViewerState extends State<FlashcardViewer> {
  int currentIndex = 0;
  int knownCount = 0;
  List cards = [];

  @override
  void initState() {
    super.initState();
    fetchDeck();
  }

  void fetchDeck() async {
    var doc = await FirebaseFirestore.instance
        .collection('decks')
        .doc(widget.deckId)
        .get();

    if (doc.exists && doc.data()?['cards'] != null) {
      DateTime now = DateTime.now();
      List allCards = List.from(doc['cards']);

      List filtered = allCards.where((card) {
        if (card['nextReview'] == null) return true;
        return DateTime.parse(card['nextReview']).isBefore(now);
      }).toList();

      setState(() {
        cards = filtered;
        cards.shuffle();
        currentIndex = 0;
        knownCount = 0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Deck not found or has no cards.")),
      );
    }
  }

  void markAsKnown() async {
    setState(() {
      knownCount++;
    });
    final updatedCard = Map<String, dynamic>.from(cards[currentIndex]);
    updatedCard['nextReview'] =
        DateTime.now().add(Duration(days: 2)).toIso8601String();
    updatedCard['known'] = true;

    cards[currentIndex] = updatedCard;

    await FirebaseFirestore.instance
        .collection('decks')
        .doc(widget.deckId)
        .update({'cards': cards});

    nextCard();
  }

  void markAsUnknown() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Marked as unknown")));
    nextCard();
  }

  void nextCard() {
    if (cards.isNotEmpty) {
      setState(() {
        currentIndex = (currentIndex + 1) % cards.length;
      });
    }
  }

  void deleteDeck() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete this deck?"),
        content: Text("This will permanently remove the deck."),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('decks')
            .doc(widget.deckId)
            .delete();

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Deck deleted")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting deck: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flashcards"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteDeck,
            tooltip: 'Delete Deck',
          ),
        ],
      ),
      body: cards.isEmpty
          ? Center(child: Text("No cards available for review."))
          : Center(
              child: Card(
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Progress: $knownCount / ${cards.length}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        cards[currentIndex]['question'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        cards[currentIndex]['answer'],
                        style: TextStyle(fontSize: 20),
                      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddCardPage(deckId: widget.deckId),
            ),
          );
          fetchDeck(); // Refresh on return
        },
        child: Icon(Icons.add),
        tooltip: 'Add Card',
      ),
    );
  }
}
