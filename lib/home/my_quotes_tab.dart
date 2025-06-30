// my_quotes_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/auth_service.dart';
import '../widgets/add_quote_sheet.dart';
import '../widgets/quote_card.dart';
import '../widgets/tab_header.dart';
import '../widgets/loading_overlay.dart';

class MyQuotesPage extends StatefulWidget {
  const MyQuotesPage({super.key});

  @override
  State<MyQuotesPage> createState() => _MyQuotesPageState();
}

class _MyQuotesPageState extends State<MyQuotesPage> {
  bool _loading = true;
  List<Map<String, String>> _myQuotes = [];

  @override
  void initState() {
    super.initState();
    _fetchQuotesFromFirestore();
  }

  Future<void> _fetchQuotesFromFirestore() async {
    try {
      final user = AuthService().currentUser;
      final uid = user?.uid;

      if (uid == null) {
        throw Exception("User not logged in.");
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('quotes')
          .where('uid', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .get();

      final quotes = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'text': (data['text'] ?? '').toString(),
          'author': (data['author'] ?? 'Unknown').toString(),
        };
      }).toList();

      setState(() {
        _myQuotes = quotes;
        _loading = false;
      });
    } catch (e) {
      debugPrint("Error fetching quotes: $e");
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _openAddQuoteSheet({Map<String, String>? quote}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AddQuoteSheet(
        onQuoteAdded: _fetchQuotesFromFirestore,
        quoteId: quote?['id'],
        initialText: quote?['text'],
        initialAuthor: quote?['author'],
        initialPublic: true,
      ),
    );
  }

  Future<void> _deleteQuote(String quoteId) async {
    try {
      await FirebaseFirestore.instance.collection('quotes').doc(quoteId).delete();
      _fetchQuotesFromFirestore();
    } catch (e) {
      debugPrint("Failed to delete quote: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete quote.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _loading,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openAddQuoteSheet(),
          icon: const Icon(Icons.add),
          label: const Text("Add Quote"),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TabHeader(title: 'My Quotes', badge: 'Yours'),
                const SizedBox(height: 24),
                _myQuotes.isEmpty
                    ? const Expanded(
                  child: Center(
                    child: Text(
                      "You haven’t added any quotes yet.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
                    : Expanded(
                  child: ListView.separated(
                    itemCount: _myQuotes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final quote = _myQuotes[index];
                      return Stack(
                        children: [
                          QuoteCard(
                            text: quote['text']!,
                            author: quote['author']!,
                            quoteId: quote['id'],
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.grey[700]),
                                  onPressed: () => _openAddQuoteSheet(quote: quote),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                                  onPressed: () async {
                                    final confirmed = await showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Delete Quote"),
                                        content: const Text("Are you sure you want to delete this quote?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx, false),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx, true),
                                            child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmed == true) {
                                      _deleteQuote(quote['id']!);
                                    }
                                  },
                                ),
                              ],
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
      ),
    );
  }
}
