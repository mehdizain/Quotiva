import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/quote_list_tile.dart';
import '../widgets/tab_header.dart';
import '../widgets/loading_overlay.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  bool _loading = true;
  List<Map<String, String>> _favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    setState(() => _loading = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() {
        _favoriteQuotes = [];
        _loading = false;
      });
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .orderBy('savedAt', descending: true)
          .get();

      final quotes = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'text': (data['text'] ?? '').toString(),
          'author': (data['author'] ?? 'Unknown').toString(),
        };
      }).toList();

      setState(() {
        _favoriteQuotes = quotes;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
      setState(() {
        _favoriteQuotes = [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _loading,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TabHeader(title: 'Favorites', badge: 'Saved'),
                const SizedBox(height: 24),
                _favoriteQuotes.isNotEmpty
                    ? Expanded(
                  child: ListView.separated(
                    itemCount: _favoriteQuotes.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final quote = _favoriteQuotes[index];
                      return QuoteListTile(
                        text: quote['text']!,
                        author: quote['author']!,
                        onTap: () {
                          // Optional: Navigate to a detailed view
                        },
                      );
                    },
                  ),
                )
                    : const Expanded(
                  child: Center(
                    child: Text(
                      "You haven't saved any quotes yet.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
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
