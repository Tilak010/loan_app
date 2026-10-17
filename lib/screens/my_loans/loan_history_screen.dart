import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

/// Loan history listing screen.
/// Placeholder — full implementation in Phase 5.
class LoanHistoryScreen extends StatelessWidget {
  const LoanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Loan History',
      icon: Icons.history_rounded,
      subtitle: 'Past loan records — Phase 5',
    );
  }
}
