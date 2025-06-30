import 'package:flutter/material.dart';

class QuoteListTile extends StatelessWidget {
  final String text;
  final String author;
  final VoidCallback? onTap;

  const QuoteListTile({
    super.key,
    required this.text,
    required this.author,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: const Icon(Icons.format_quote_rounded, color: Colors.indigo),
        title: Text(
          '"$text"',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '- $author',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        onTap: onTap,
      ),
    );
  }
}
