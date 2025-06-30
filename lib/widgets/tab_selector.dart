import 'package:flutter/material.dart';
import '../styles/tab_bar_styles.dart';

class TabSelector extends StatelessWidget {
  final TabController controller;
  final List<String> labels;

  const TabSelector({
    super.key,
    required this.controller,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTabStyles.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppTabStyles.activeBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        labelColor: AppTabStyles.activeTextColor,
        unselectedLabelColor: AppTabStyles.inactiveTextColor,
        labelStyle: AppTabStyles.labelStyle,
        unselectedLabelStyle: AppTabStyles.unselectedLabelStyle,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        indicatorPadding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: labels
            .map(
              (label) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(label),
          ),
        )
            .toList(),
      ),
    );
  }
}
