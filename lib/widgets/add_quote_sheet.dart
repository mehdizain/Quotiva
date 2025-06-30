import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddQuoteSheet extends StatefulWidget {
  final VoidCallback onQuoteAdded;
  final String? quoteId;
  final String? initialText;
  final String? initialAuthor;
  final bool initialPublic;

  const AddQuoteSheet({
    super.key,
    required this.onQuoteAdded,
    this.quoteId,
    this.initialText,
    this.initialAuthor,
    this.initialPublic = true,
  });

  @override
  State<AddQuoteSheet> createState() => _AddQuoteSheetState();
}

class _AddQuoteSheetState extends State<AddQuoteSheet> {
  final _quoteController = TextEditingController();
  final _authorController = TextEditingController();
  bool _saving = false;
  late bool _makePublic;

  @override
  void initState() {
    super.initState();
    _quoteController.text = widget.initialText ?? '';
    _authorController.text = widget.initialAuthor ?? '';
    _makePublic = widget.initialPublic;
  }

  Future<void> _saveQuote() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _quoteController.text.trim().isEmpty) return;

    setState(() => _saving = true);

    try {
      final data = {
        'text': _quoteController.text.trim(),
        'author': _authorController.text.trim().isEmpty
            ? 'Unknown'
            : _authorController.text.trim(),
        'uid': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'public': _makePublic,
      };

      if (widget.quoteId != null) {
        await FirebaseFirestore.instance
            .collection('quotes')
            .doc(widget.quoteId)
            .update(data);
      } else {
        await FirebaseFirestore.instance.collection('quotes').add(data);
      }

      widget.onQuoteAdded();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save quote: $e")),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.quoteId == null ? "Add a new quote" : "Edit Quote",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _quoteController,
            decoration: const InputDecoration(
              labelText: 'Quote',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _authorController,
            decoration: const InputDecoration(
              labelText: 'Author (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text("Make this quote public"),
            value: _makePublic,
            onChanged: (val) => setState(() => _makePublic = val),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: _saving
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.save),
              label: Text(_saving
                  ? (widget.quoteId != null ? "Updating..." : "Saving...")
                  : (widget.quoteId != null ? "Update Quote" : "Save Quote")),
              onPressed: _saving ? null : _saveQuote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[700],
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
