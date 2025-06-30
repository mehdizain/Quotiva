import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/quote_card.dart';
import '../widgets/modernbutton.dart';
import '../widgets/social_buttons.dart';
import '../widgets/tab_header.dart';
import '../widgets/loading_overlay.dart';

class DailyTab extends StatefulWidget {
  const DailyTab({super.key});

  @override
  State<DailyTab> createState() => _DailyTabState();
}

class _DailyTabState extends State<DailyTab> {
  bool _loading = true;
  bool _error = false;
  Map<String, String>? _quote;

  @override
  void initState() {
    super.initState();
    _fetchRandomQuote();
  }

  Future<void> _fetchRandomQuote() async {
    setState(() {
      _loading = true;
      _error = false;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('quotes')
          .where('public', isEqualTo: true)
          .get();

      final docs = snapshot.docs;
      if (docs.isEmpty) {
        setState(() {
          _quote = null;
          _loading = false;
        });
        return;
      }

      final randomDoc = docs[Random().nextInt(docs.length)];
      final data = randomDoc.data();

      setState(() {
        _quote = {
          'id': randomDoc.id,
          'text': (data['text'] ?? '').toString(),
          'author': (data['author'] ?? 'Unknown').toString(),
        };
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error loading daily quote: $e');
      setState(() {
        _loading = false;
        _error = true;
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TabHeader(title: 'Daily Inspiration', badge: 'Today'),
              const SizedBox(height: 32),
              _error
                  ? Center(
                child: Text(
                  'Failed to load quote.\nTap below to retry.',
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
              )
                  : _quote == null
                  ? const Center(child: Text('No public quotes available yet.'))
                  : QuoteCard(
                text: _quote!['text']!,
                author: _quote!['author']!,
                quoteId: _quote!['id']!,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Modernbutton(
                  text: _error ? 'Retry' : 'New Quote',
                  onPressed: _fetchRandomQuote,
                  icon: Icons.refresh,
                ),
              ),
              const SizedBox(height: 16),
              SocialButtons(onGoogleTap: () {}, onFacebookTap: () {}),
            ],
          ),
          ),
        ),
      ),
    )
    );
  }
}
