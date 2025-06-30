import 'package:flutter/material.dart';
import 'modernbutton.dart';

class QuoteNavigator extends StatelessWidget {
  final VoidCallback onNext;

  const QuoteNavigator({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Modernbutton(
        text: 'Next Quote',
        onPressed: onNext,
        icon: Icons.navigate_next,
      ),
    );
  }
}
